require 'spec_helper'

module Jimson
  describe Middleware do

    class FooHandler
      extend Jimson::Handler

      def bar(params)
        params[:a]
      end

    end

    class FooMiddleware < Middleware

      def process(command, params=nil)
        params = {} if params.nil?
        params = { original_params: params } if params.is_a?(Array)
        params[:a] = 'injected'
        params
      end

    end

    let(:server) { Server.new(FooHandler.new, {middlewares: FooMiddleware.new}) }

    describe '#process' do
      it 'processes the params' do
        expect(server.dispatch_request(:bar, nil)).to eq('injected')
      end
    end

  end
end

