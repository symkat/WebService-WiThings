package WebService::WiThings::Request::AuthorizeToken;
use Moo;
with 'WebService::WiThings::Request';

has api_endpoint => (
    is          => 'ro',
    default     => sub { 'https://oauth.withings.com/account/access_token' },
);

has user_id => (
    is          => 'ro',
);

has query_params => (
    is          => 'lazy',
);

sub _build_query_params {
    my ( $self ) = @_;

    return {
        userid             => $self->user_id,
    };
};

1;
