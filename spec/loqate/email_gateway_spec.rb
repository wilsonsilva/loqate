require 'loqate/email_gateway'

RSpec.describe Loqate::EmailGateway, vcr: true do
  let(:dev_api_key)   { File.read(File.dirname(__FILE__) + '/../../.api_key').strip }
  let(:configuration) { Loqate::Configuration.new(api_key: dev_api_key) }
  let(:client)        { Loqate::Client.new(configuration) }
  let(:email_gateway) { described_class.new(client) }

  describe '#batch_validate' do
    context 'when invoked without a list of emails' do
      it 'returns an error' do
        result = email_gateway.batch_validate({})

        expect(result.value).to eq(
          Loqate::Error.new(
            cause: 'No email addresses were supplied',
            description: 'Emails Required',
            id: 1001,
            resolution: 'Check that you have betweeon 1 and 100 emails in the batch and try again.'
          )
        )
      end
    end

    context 'when invoked with a list of emails' do
      it 'returns multiple validation results' do
        result = email_gateway.batch_validate(emails: %w[not_an_email contact@wilsonsilva.net temp@dispostable.com])

        expect(result.value).to contain_exactly(
          Loqate::BatchEmailValidation.new(
            status: 'Invalid',
            email_address: 'not_an_email',
            account: '',
            domain: '',
            is_disposible: false,
            is_system_mailbox: false
          ),
          Loqate::BatchEmailValidation.new(
            status: 'Valid',
            email_address: 'contact@wilsonsilva.net',
            account: 'contact',
            domain: 'wilsonsilva.net',
            is_disposible: false,
            is_system_mailbox: true
          ),
          Loqate::BatchEmailValidation.new(
            status: 'Unknown',
            email_address: 'temp@dispostable.com',
            account: 'temp',
            domain: 'dispostable.com',
            is_disposible: true,
            is_system_mailbox: false
          )
        )
      end
    end
  end

  describe '#batch_validate!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        email_validations = email_gateway.batch_validate!(emails: %w[contact@wilsonsilva.net])

        expect(email_validations).to contain_exactly(
          Loqate::BatchEmailValidation.new(
            status: 'Valid',
            email_address: 'contact@wilsonsilva.net',
            account: 'contact',
            domain: 'wilsonsilva.net',
            is_disposible: false,
            is_system_mailbox: true
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          email_gateway.batch_validate!(emailees: 'whatevz')
        end.to raise_error(Loqate::Error, 'Emails Required')
      end
    end
  end

  describe '#validate' do
    context 'when invoked without an email' do
      let(:error) do
        Loqate::Error.new(
          cause: 'The Email is required.',
          description: 'Email Required',
          id: 1001,
          resolution: 'Please ensure that you supply a valid Email address and try again.'
        )
      end

      it 'returns an error' do
        result = email_gateway.validate({})
        expect(result.value).to eq(error)
      end
    end

    context 'when the email is valid' do
      it 'returns a valid email validation' do
        result = email_gateway.validate(email: 'wilson.silva@gmail.com')

        expect(result.value).to eq(
          Loqate::EmailValidation.new(
            response_code: 'Valid',
            response_message: 'Email address was fully validated',
            email_address: 'wilson.silva@gmail.com',
            user_account: 'wilson.silva',
            domain: 'gmail.com',
            is_disposable_or_temporary: false,
            is_complainer_or_fraud_risk: false,
            duration: 0.007366261
          )
        )
      end
    end

    context 'when only the email domain was validated' do
      it 'returns a partially valid email validation' do
        result = email_gateway.validate(email: 'contact@wilsonsilva.net')

        expect(result.value).to eq(
          Loqate::EmailValidation.new(
            response_code: 'Valid_CatchAll',
            response_message: 'Mail is routable to the domain but account could not be validated',
            email_address: 'contact@wilsonsilva.net',
            user_account: 'contact',
            domain: 'wilsonsilva.net',
            is_disposable_or_temporary: false,
            is_complainer_or_fraud_risk: false,
            duration: 0.241566504
          )
        )
      end
    end

    context 'when the email is invalid' do
      it 'returns an invalid email validation' do
        result = email_gateway.validate(email: '404@404.pl')

        expect(result.value).to eq(
          Loqate::EmailValidation.new(
            response_code: 'Invalid',
            response_message: 'Email Address is not valid',
            email_address: '404@404.pl',
            user_account: '404',
            domain: '404.pl',
            is_disposable_or_temporary: false,
            is_complainer_or_fraud_risk: false,
            duration: 0.009907195
          )
        )
      end
    end
  end

  describe '#validate!' do
    context 'when the result is successful' do
      it 'returns the unwrapped result' do
        email_validation = email_gateway.validate!(email: 'contact@wilsonsilva.net')

        expect(email_validation).to eq(
          Loqate::EmailValidation.new(
            response_code: 'Valid_CatchAll',
            response_message: 'Mail is routable to the domain but account could not be validated',
            email_address: 'contact@wilsonsilva.net',
            user_account: 'contact',
            domain: 'wilsonsilva.net',
            is_disposable_or_temporary: false,
            is_complainer_or_fraud_risk: false,
            duration: 0.241566504
          )
        )
      end
    end

    context 'when the result is not successful' do
      it 'raises an error' do
        expect do
          email_gateway.validate!(emailee: 'whatevz')
        end.to raise_error(Loqate::Error, 'Email Required')
      end
    end
  end
end
