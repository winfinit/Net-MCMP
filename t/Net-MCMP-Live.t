use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 27;

use_ok( 'Net::MCMP', 'use mcmp' );

my $mcmp_uri = 'http://127.0.0.1:6666';
my $mcmp = Net::MCMP->new( { uri => $mcmp_uri } );

is( ref $mcmp,  'Net::MCMP',    'making sure object created' );
is( $mcmp->uri, $mcmp_uri, 'making sure URI is returned correctly' );
ok(
	$mcmp->config(
		{
			StickySession       => 'yes',
			StickySessionCookie => 'session',
			StickySessionPath   => '',
			JvmRoute            => 'MyJVMRoute',
			Domain              => 'Foo',
			Host                => 'localhost',
			Port                => '3000',
			Type                => 'http',
			Context             => '/cluster',
			Alias               => 'SomeHost',
		}
	),
	'checking config'
);
ok( !$mcmp->has_error, 'no errors' );

ok(
	my $ping_resp = $mcmp->ping(
		{
			JvmRoute => 'MyJVMRoute',
		}
	),
	'ping command'
);


ok( !$mcmp->has_error, 'no errors' );


ok(
	$mcmp->enable_app(
		{
			JvmRoute => 'MyJVMRoute',
			Alias    => 'SomeHost',
			Context  => '/cluster'
		}
	),
	'enable context'
);

ok( !$mcmp->has_error, 'no errors' );

ok(
	my $status_resp = $mcmp->status(
		{
			JvmRoute => 'MyJVMRoute',
			Load     => 55,
		}
	),
	'status'
);

#$VAR1 = {
#          'State' => 'OK',
#          'JVMRoute' => 'MyJVMRoute',
#          'id' => '-297586570',
#          'Type' => 'STATUS-RSP'
#        };

is( $status_resp->{'State'}, 'OK', 'status State response');
is( $status_resp->{'JVMRoute'}, 'MyJVMRoute', 'status JVMRoute response');
is( $status_resp->{'Type'}, 'STATUS-RSP', 'status Type response');
ok( $status_resp->{'id'}, 'status id response');

#Type=STATUS-RSP&JVMRoute=MyJVMRoute&State=OK&id=-297586570

ok( !$mcmp->has_error, 'no errors' );

ok(
	$mcmp->disable_app(
		{
			JvmRoute => 'MyJVMRoute',
			Alias    => 'SomeHost',
			Context  => '/cluster'
		}
	),
	'disable context'
);

ok( !$mcmp->has_error, 'no errors' );

ok(
	$mcmp->stop_app(
		{
			JvmRoute => 'MyJVMRoute',
			Alias    => 'SomeHost',
			Context  => '/cluster'
		}
	),
	'stop context'
);

ok( !$mcmp->has_error, 'no errors' );

ok(
	$mcmp->enable_route(
		{
			JvmRoute => 'MyJVMRoute',
		}
	),
	'enable route'
);

ok( !$mcmp->has_error, 'no errors' );

ok(
	$mcmp->disable_route(
		{
			JvmRoute => 'MyJVMRoute',
		}
	),
	'disable route'
);

ok( !$mcmp->has_error, 'no errors' );

ok(
	$mcmp->stop_route(
		{
			JvmRoute => 'MyJVMRoute',
		}
	),
	'stop route'
);

ok( !$mcmp->has_error, 'no errors' );

ok(
	$mcmp->remove_app(
		{
			JvmRoute => 'MyJVMRoute',
			Alias    => 'SomeHost',
			Context  => '/cluster'
		}
	),
	'remove context'
);

ok( !$mcmp->has_error, 'no errors' );

ok(
	$mcmp->remove_route(
		{
			JvmRoute => 'MyJVMRoute',
		}
	),
	'remove route'
);

ok( !$mcmp->has_error, 'no errors' );

