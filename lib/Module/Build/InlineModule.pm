use strict; use warnings;
package Module::Build::InlineModule;
our $VERSION = '0.02';

use base 'Module::Build';
__PACKAGE__->add_property('inline');

use Inline::Module();

sub ACTION_code {
    my $self = shift;
    $self->SUPER::ACTION_code(@_);
    my $inline = $self->get_inline;
    my @inc = @INC;
    local @INC = (
        (-e 'inc' ? ('inc') : ()),
        'lib',
        @inc,
    );
    for my $module (@{$inline->{module}}) {
        eval "require $module; 1" or die $@;
    }
    Inline::Module->handle_fixblib;
}

sub ACTION_distdir {
    my $self = shift;
    $self->SUPER::ACTION_distdir(@_);
    my $distdir = $self->dist_dir;
    my $inline = $self->get_inline;

    my $inline_module = Inline::Module->new(%$inline);
    my $stub_modules = $inline->{stub};
    my @included_modules = $inline_module->included_modules;

    Inline::Module->handle_distdir(
        $distdir,
        @$stub_modules,
        '--',
        @included_modules,
    );
}

# Replace this with call to Inline::Module
sub get_inline {
    my $self = shift;
    my $inline = $self->{properties}{inline}
        or die "Missing Module::Build property: 'inline'";
    $inline->{module} or die
        "Module::Build::InlineModule property 'inline' missing key 'module'";
    $inline->{module} = [$inline->{module}] unless ref $inline->{module};
    $inline->{stub} ||= [ map "${_}::Inline", @{$inline->{module}} ];
    $inline->{stub} = [$inline->{stub}] unless ref $inline->{stub};
    $inline->{ilsm} ||= 'Inline::C';
    $inline->{ilsm} = [$inline->{ilsm}] unless ref $inline->{ilsm};
    return $inline;
}

1;
