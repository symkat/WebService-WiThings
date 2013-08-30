package WebService::WiThings::Request::GetUserMeasurements;
use Moo;
with 'WebService::WiThings::Request';

has api_endpoint => (
    is          => "ro",
    default     => sub { "http://wbsapi.withings.net/measure" },
);

has user_id => (
    is          => 'ro',
    required    => 1,
);

has query_params => (
    is          => "lazy",
);

sub _build_query_params {
    my ( $self ) = @_;

    return {
        action             => "getmeas",
        userid             => $self->user_id,
    };
};

1;
