package Data::Section::TestBase;
use strict;
use warnings;
use utf8;

use parent qw/Exporter/;
our @EXPORT = qw/blocks/;
use Text::TestBase;

our $VERSION = '0.12';

sub new {
    my $class = shift;
    my %args= @_==1 ? %{$_[0]} : @_;
    bless { %args }, $class;
}

sub blocks() {
    my $self = ref $_[0] ? shift : __PACKAGE__->new(package => scalar caller);

    my $d = do { no strict 'refs'; \*{$self->{package}."::DATA"} };
    return unless defined fileno $d;

    seek $d, 0, 0;

    my $line_offset = 0;

    my $content = join '', <$d>;

    my $parser = Text::TestBase->new();
    my @blocks = $parser->parse($content);
    for my $block (@blocks) {
        $block->{_lineno} += $line_offset;
    }
    return @blocks;
}

1;
__END__

=head1 NAME

Data::Section::TestBase - Parse Test::Base format from DATA section

=head1 SYNOPSIS

    use Data::Section::TestBase;

    my @blocks = blocks;

=head1 DESCRIPTION

This module parse a DATA section as Test::Base format by L<Text::TestBase>.

=head1 FUNCTIONS

=over 4

=item my @blocks = blocks();

Get a list of blocks from DATA section Element of @list is a instance of Text::TestBase::Block.

=back

