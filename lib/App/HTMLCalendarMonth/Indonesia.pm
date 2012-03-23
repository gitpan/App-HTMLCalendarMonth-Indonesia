package App::HTMLCalendarMonth::Indonesia;

use 5.010;
use strict;
use warnings;

use DateTime;
use HTML::CalendarMonth;
use Calendar::Indonesia::Holiday qw(list_id_holidays);

use Exporter::Lite;
our @EXPORT_OK = qw(gen_id_mon_calendar);

our $VERSION = '0.04'; # VERSION

# Translations to Indonesian
my %translations = (
    # Month names
    January   => 'Januari',
    February  => 'Februari',
    March     => 'Maret',
    April     => 'April',
    May       => 'Mwi',
    June      => 'Juni',
    July      => 'Juli',
    August    => 'Agustus',
    September => 'September',
    October   => 'Oktober',
    November  => 'November',
    December  => 'Desember',

    # Day abreviations
    Su => 'Mg',
    M  => 'Sn',
    Tu => 'Sl',
    W  => 'Rb',
    Th => 'Km',
    F  => 'Ju',
    Sa => 'Sb',
);

our %SPEC;

$SPEC{gen_id_mon_calendar} = {
    summary => 'Generate Indonesian monthly HTML calendar',
    description => <<'_',

This function uses HTML::CalendarMonth and Calendar::Indonesian::Holiday to
generate monthly HTML calendar, with Indonesian holidays marked as CSS class
(classes: sunday, holiday), and holiday names in TITLE attributes.

_
    args    => {
        year => ['int' => {
            description => 'Defaults to current year if not specified',
            arg_pos     => 0,
        }],
        month => ['int' => {
            description => 'Defaults to current month if not specified',
            arg_pos     => 1,
        }],
        holidays => ['array' => {
            summary     => 'If specified, use this list of holidays',
            description => <<'_',

If not specified, list of holidays is retrieved from
Calendar::Indonesia::Holiday.

Should be a list of YYYY-MM-DD date strings

_
            of          => 'str*',
            arg_pos     => 1,
        }],
        postprocess => [code => {
            summary => 'If supplied, code will get HTML::Calendar object',
            description => <<'_',

Can be used to customize the output further.

_
        }],
    },
};
sub gen_id_mon_calendar {
    my %args = @_;

    my $today = DateTime->today();

    # XXX schema
    my $year  = $args{year}  // $today->year;
    my $month = $args{month} // $today->month;
    my $holidays = $args{holidays};

    if (!$holidays) {
        my $res = list_id_holidays(year=>$year, month=>$month,
                                   is_joint_leave=>0);
        return [500, "Can't get list of holidays: $res->[0] - $res->[1]"]
            unless $res->[0] == 200;
        $holidays = $res->[2];
    }
    my $fdom = DateTime->new(year=>$year, month=>$month, day=>1);
    my $ldom = DateTime->last_day_of_month(year=>$year, month=>$month);
    my $date = $fdom;

    my $c = HTML::CalendarMonth->new(
        year=>$year, month=>$month,
        week_begin=>2, alias=>\%translations);
    for my $day (1..$ldom->day) {
        my @class;
        if ($date->day_of_week == 7) { push @class, "sunday" }
        my $d = sprintf("%04d-%02d-%02d", $year, $month, $day);
        if ($d ~~ @$holidays) {
            push @class, "holiday";
        }
        if (@class) { $c->item($day)->attr(class => join(" ", @class)) }
        $date->add(days => 1);
    }

    if ($args{postprocess}) {
        $args{postprocess}->($c);
    }
    [200, "OK", $c->as_HTML];
}

1;
#ABSTRACT: Generate Indonesian monthly HTML calendar


__END__
=pod

=head1 NAME

App::HTMLCalendarMonth::Indonesia - Generate Indonesian monthly HTML calendar

=head1 VERSION

version 0.04

=head1 SYNOPSIS

 # See gen-id-mon-calendar script for command-line usage

=head1 DESCRIPTION

=head1 FUNCTIONS

None are exported, but they are exportable.

=head1 FUNCTIONS


=head2 gen_id_mon_calendar(%args) -> [status, msg, result, meta]

Generate Indonesian monthly HTML calendar.

This function uses HTML::CalendarMonth and Calendar::Indonesian::Holiday to
generate monthly HTML calendar, with Indonesian holidays marked as CSS class
(classes: sunday, holiday), and holiday names in TITLE attributes.

Arguments ('*' denotes required arguments):

=over 4

=item * B<holidays> => I<array>

If specified, use this list of holidays.

If not specified, list of holidays is retrieved from
Calendar::Indonesia::Holiday.

Should be a list of YYYY-MM-DD date strings

=item * B<month> => I<int>

Defaults to current month if not specified

=item * B<postprocess> => I<code>

If supplied, code will get HTML::Calendar object.

Can be used to customize the output further.

=item * B<year> => I<int>

Defaults to current year if not specified

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

