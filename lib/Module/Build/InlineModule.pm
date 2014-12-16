package Module::Build::InlineModule;
our $VERSION = '0.01';

use base 'Module::Build';
__PACKAGE__->add_property('inline');

use Inline::Module();

use XXX;

sub ACTION_code {
    my ($self) = @_;
    my $module = $self->{properties}{inline}{module};
    eval "require $module; 1" or die @_;
}

sub ACTION_distdir {
    XXX "ACTION_distdir", @_;
}

1;
