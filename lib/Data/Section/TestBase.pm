package Data::Section::TestBase;
use strict;
use warnings;
use utf8;

use parent qw/Exporter/;
our @EXPORT = qw/blocks/;
use Text::TestBase;

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
    my $content = join '', <$d>;
    my $parser = Text::TestBase->new();
    my @blocks = $parser->parse($content);
    return @blocks;
}

1;
__END__

=head1 SYNOPSIS

    use Data::Section::TestBase;

    my @blocks = blocks;

