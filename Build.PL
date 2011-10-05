
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Module::Build' => '0.3601'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Generate Indonesian monthly HTML calendar',
  'dist_author' => [
    'Steven Haryanto <stevenharyanto@gmail.com>'
  ],
  'dist_name' => 'App-HTMLCalendarMonth-Indonesia',
  'dist_version' => '0.02',
  'license' => 'perl',
  'module_name' => 'App::HTMLCalendarMonth::Indonesia',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Calendar::Indonesia::Holiday' => '0',
    'DateTime' => '0',
    'Exporter::Lite' => '0',
    'HTML::CalendarMonth' => '0',
    'Test::More' => '0.96',
    'perl' => '5.010000'
  },
  'script_files' => [
    'bin/gen-id-mon-calendar'
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
