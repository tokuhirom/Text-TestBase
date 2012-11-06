package Text::TestBase;
use strict;
use warnings;
use 5.008001;
our $VERSION = '0.03';

use Class::Accessor::Lite (
    rw => [qw/block_delim data_delim block_class/],
);
use Carp ();

use Text::TestBase::Block;

sub new {
    my $class = shift;
    my %args = @_==1 ? %{$_[0]} : @_;
    bless {
        block_delim => '===',
        data_delim => '---',
        block_class => 'Text::TestBase::Block',
        %args,
    }, $class;
}

sub parse {
    my ($self, $spec) = @_;
    my $cd = $self->block_delim;
    my @hunks = ($spec =~ /^(\Q${cd}\E.*?(?=^\Q${cd}\E|\z))/msg);

    my @blocks;
    my $lineno = 1;
    for my $hunk (@hunks) {
        push @blocks, $self->_make_block($hunk, $lineno);
        $lineno += scalar(split /\n/, $hunk) + 1;
    }
    return @blocks;
}

sub _make_block {
    my ($self, $hunk, $lineno) = @_;

    my $cd = $self->block_delim;
    my $dd = $self->data_delim;
    $hunk =~ s/\A\Q${cd}\E[ \t]*(.*)\s+// or die;
    my $name = $1;
    my @parts = split /^\Q${dd}\E +\(?(\w+)\)? *(.*)?\n/m, $hunk;
    my $description = shift @parts;
    $description ||= '';
    unless ($description =~ /\S/) {
        $description = $name;
    }
    $description =~ s/\s*\z//;
    my $block = $self->block_class->new(
        description => $description,
        name        => $name,
        _lineno     => $lineno,
    );
    
    my $filter_map = {};
    my $section_order = [];
    while (@parts) {
        my ($type, $filters, $value) = splice(@parts, 0, 3);
        $self->_check_reserved($type);
        $value = '' unless defined $value;
        $filters = '' unless defined $filters;
        if ($filters =~ /:(\s|\z)/) {
            Carp::croak "Extra lines not allowed in '$type' section"
              if $value =~ /\S/;
            ($filters, $value) = split /\s*:(?:\s+|\z)/, $filters, 2;
            $value = '' unless defined $value;
            $value =~ s/^\s*(.*?)\s*$/$1/;
        }
        $block->push_section($type, $value, $filters);
    }
    return $block;
}

my $reserved_section_names = {};
{
    %$reserved_section_names = map {
        ($_, 1);
    } keys(%Text::TestBase::Block::), qw( new DESTROY );
}
sub _check_reserved {
    my $id = shift;
    Carp::croak "'$id' is a reserved name. Use something else.\n"
      if $reserved_section_names->{$id} or
         $id =~ /^_/ or $id =~ /^(get_|set_|push_)/;
}


1;
__END__

=encoding utf8

=head1 NAME

Text::TestBase - Parser for Test::Base format

=head1 SYNOPSIS

    use Text::TestBase;

    my $parser = Text::TestBase->new();
    $parser->parse(<<'...');
    === hogehoge
    --- input: yyy
    --- got: xxx
    ...

=head1 DESCRIPTION

Text::TestBase is a parser for Test::Base format.

=head1 MOTIVATION

I love Test::Base. But it's bit too magical. It uses Spiffy, and it depends to YAML.
Test::Base breaks my distribution sometime. I need more simple implementation for Test::Base format.

=head1 METHODS

=over 4

=item my $parser = Text::TestBase->new();

Create new parser instance.

=item $parser->parse($src: Str): List of Text::TestBase::Block

Parse $src and get a list of L<Text::TestBase::Block>

=back

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF@ GMAIL COME<gt>

=head1 SEE ALSO

Most of the code was taken from L<Test::Base>, of course.

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
