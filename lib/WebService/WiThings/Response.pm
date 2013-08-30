package WebService::WiThings::Response;
use Moo::Role;
use JSON qw( decode_json );

has oauth_consumer_key => ( is => 'ro' );
has oauth_token_secret => ( is => 'ro' );

has response => (
    is => 'ro',
    isa => sub { ref $_[0] eq 'LWP::Authen::OAuth' },
);

has json => ( is => 'lazy' );

has body_args => ( is => 'lazy' );

sub _build_body_args {
    my ( $self ) = @_;
    my %data;

    my $str = $self->response->content;
    return {} unless $str;
    pos($str) = 0;

    while ( pos($str)  != length($str) ) {
        if ( $str =~ /\G([^=]+)=([^&]+)&?/gc ) {
            $data{$1} = $2;
        } else {
            return {}; # Unable to handle this type of data.
        }
    }
    return \%data;
}

1;
