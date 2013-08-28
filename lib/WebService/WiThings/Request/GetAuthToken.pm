package WebService::WiThings::Request::GetAuthToken;
use Moo;
use URI::Encode qw( uri_encode );
with 'WebService::WiThings::Request';

has oauth_callback => (
    is          => 'ro',
);

has endpoint => (
    is          => 'ro',
    default     => sub { "account/request_token" },
);

has query_params => (
    is          => 'lazy',
);

sub _build_query_params {
    my ( $self ) = @_;

    return unless $self->oauth_callback;
    return ( { "oauth_callback" => $self->oauth_callback } );
}

sub as_exception {
    my ( $self ) = @_;
    return "Query Params: " . join( ", ", $self->query_params ) . " for enpoint " . $self->endpoint;
}


1;
