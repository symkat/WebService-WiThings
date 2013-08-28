package WebService::WiThings;
use warnings;
use strict;
use Moo;
use LWP::Authen::OAuth;
use Module::Load;
use Try::Tiny;
use Scalar::Util qw( looks_like_number );
use Data::Dumper;

our $VERSION = '0.001000'; $VERSION = eval $VERSION;

has oauth_consumer_secret => ( is => 'ro' );
has oauth_consumer_key    => ( is => 'ro' );

has api_base => ( 
    is => 'ro', 
    default => sub { "https://oauth.withings.com/" } 
);

has 'user_agent' => ( 
    is => 'ro', 
    default => sub { "WebService::WiThings/$VERSION" },
);

has 'http_timeout' => ( 
    is => 'ro', 
    isa => sub { looks_like_number $_[0] },
    default => sub { 60 } 
);

has ua => ( 
    is => 'lazy', 
    isa => sub { ref $_[0] eq 'LWP::Authen::OAuth' } 
);


sub call {
    my ( $self, $class, $args ) = @_;

    try {
        load("WebService::WiThings::Request::$class");
    } catch {
        $self->_throw_exception(
            msg => "WebService::WiThings::Request::$class wasn't found.",
            line    => __LINE__,
            package => __PACKAGE__,
            args    => [ $class ],
            from    => $_, # The Compile Error.
        );
    };

    # Create Request Object
    my $request = try {
        "WebService::WiThings::Request::$class"->new( $args );
    } catch {
        $self->_throw_exception(
            msg         => "Creating API Request",
            line        => __LINE__,
            package     => __PACKAGE__,
            args        => [ $class, %{ $args } ],
            from        => $_, # Likely a WS::WT::Exception
        );
    };
    
    # Make HTTP Request
    my $http_response = try {
        $self->_do_call( $request );
    } catch {
        $self->_throw_exception(
            msg         => "Making HTTP Call",
            line        => __LINE__,
            package     => __PACKAGE__,
            args        => [ $class, %{ $args } ],
            from        => $_, # Likely a WS::FB::Exception
        );
    };

    # Create Response Object
    my $response = try {
        $self->_create_response( $class, $http_response );
    } catch {
        $self->_throw_exception (
            msg         => "Creating Response Object from API Call",
            line        => __LINE__,
            package     => __PACKAGE__,
            args        => [ $class, %{ $args } ],
            from        => $_, # Likely a WS::WT::Exception
        );
    };

    return $response;
}

sub _throw_exception {
    my ( $self, %args ) = @_;

    die Dumper( \%args );

}

sub _do_call {
    my ( $self, $request ) = @_;

    # This should be able to be updated between API calls.
    $self->ua->default_header( "Accept-Language", $request->language );

    # Update OAuth Parameters.
    for my $param (qw(oauth_consumer_key oauth_token oauth_token_secret)) {
        $self->ua->$param( $request->$param ) if $request->can($param) && $request->$param;
    }

    my $http_response;

    if ( $request->type eq 'POST' ) {
        $http_response = try { 
            $self->ua->post( $self->api_base . $request->endpoint, $request->post_arguments );
        } catch {
            $self->_throw_exception (
                msg         => "Making HTTP Post",
                line        => __LINE__,
                package     => __PACKAGE__,
                args        => [ $request->as_exception ],
                from        => $_, # Likely a WS::WT::Exception
            );
        };
    } elsif ( $request->type eq 'GET' ) {
        $http_response = try { 
            $self->ua->get( $self->api_base . $request->endpoint . $request->query_string,
                @{ $request->headers }
            );
        } catch {
            $self->_throw_exception (
                msg         => "Making HTTP GET",
                line        => __LINE__,
                package     => __PACKAGE__,
                args        => [ $request->as_exception ],
                from        => $_, # Likely a WS::WT::Exception
            );
        };
    }

    return $http_response;
}

sub _create_response {
    my ( $self, $class, $http_response ) = @_;

    # Load response object.
    try {
        load("WebService::WiThings::Response::$class");
    } catch {
        $self->_throw_exception(
            msg => "WebService::WiThings::Response::$class wasn't found.",
            line    => __LINE__,
            package => __PACKAGE__,
            args    => [ $class ],
            from    => $_, # The Compile Error.
        );
    };

    # Create Request Object
    my $response = try {
        "WebService::WiThings::Response::$class"->new( { response => $http_response } );
    } catch {
        $self->_throw_exception(
            msg         => "Creating API Response",
            line        => __LINE__,
            package     => __PACKAGE__,
            args        => [ $class, %{ $http_response } ],
            from        => $_, # Likely a WS::WT::Exception
        );
    };

    return $response;
}

sub _build_ua {
    my ( $self ) = @_;

    my $ua = LWP::Authen::OAuth->new(
        oauth_consumer_secret => $self->oauth_consumer_secret,
        timeout               => $self->http_timeout,
        agent                 => $self->user_agent,
    );
    
    return $ua;
}

1;
=head1 NAME

=head1 DESCRIPTION

=head1 SYNOPSIS

=head1 CONSTRUCTOR

=head1 AUTHOR

=over 4

Kaitlyn Parkhurst (SymKat) I<E<lt>symkat@symkat.comE<gt>> ( Blog: L<http://symkat.com/> )

=back

=head1 CONTRIBUTORS

=over 4

=item * None Yet

=back

=head1 SPONSORS

Parts of this code were paid for by

=over 4

=item WeightGrapher L<http://www.weightgrapher.com/>

=back

=head1 COPYRIGHT

Copyright (c) 2013 the WebService::WiThings L</AUTHOR>, L</CONTRIBUTORS>, and L</SPONSORS> as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms as perl itself.

=head1 AVAILABILITY

The most current version of WebService::WiThings can be found at L<https://github.com/symkat/WebService-WiThings>

