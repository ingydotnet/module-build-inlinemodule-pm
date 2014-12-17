package Module::Build::InlineModule;
our $VERSION = '0.01';

use base 'Module::Build';
__PACKAGE__->add_property('inline');

use Inline::Module();

    use XXX;

sub ACTION_code {
    my $self = shift;
    $self->SUPER::ACTION_code(@_);
    my $module = $self->{properties}{inline}{module};
    print "$module\n";
    my @inc = @INC;
    local @INC = ('lib', @inc);
    eval "require $module; 1" or die $@;
    Inline::Module->handle_fixblib;
}

sub ACTION_distdir {
    XXX "ACTION_distdir", @_;
}

1;
