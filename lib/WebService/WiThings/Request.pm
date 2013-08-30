package WebService::WiThings::Request;
use Moo::Role;
use URI::Encode qw( uri_encode );

has oauth_consumer_key => ( is => 'ro' );
has oauth_token_secret => ( is => 'ro' );
has oauth_token        => ( is => 'ro' );

has type => (
    is          => 'rw',
    default     => sub { "GET" },
    isa         => sub { $_[0] eq 'GET' || $_[0] eq 'POST' },
);

has 'language' => (
    is          => 'rw',
    default     => sub { "en_US" },
    isa         => sub { $_[0] =~ /^en_(US|GB|KG)$/ },
);

has 'query_params' => (
    is          => 'rw',
    default     => sub { {} },
    isa         => sub { ref $_[0] eq 'HASH' },
);

has 'headers' => (
    is          => 'rw',
    default     => sub { [] },
    isa         => sub { ref $_[0] eq 'ARRAY' },
);

has 'query_string' => (
    is          => 'lazy',
);

sub as_exception { 
    return shift; 
}

1;  
