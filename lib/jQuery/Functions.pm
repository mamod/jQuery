package jQuery::Functions;

use strict;
use subs 'this';
use warnings;
use HTTP::Request::Common qw(POST GET);
use LWP::UserAgent;

our $VERSION = '0.006';

my $base_class = 'jQuery';
my $obj_class = 'jQuery::Obj';
my $element_class = 'XML::LibXML::Element';

=head1 Methods

=cut
sub jQuery { return jQuery::jQuery(@_) }

#internal sub
sub editElement {

   my ($self,$attr,$value,$remove_old) = @_;
   
    foreach my $element ($self->getNodes){
        
        my $cur_value;
        my $new = $value;
        
        if ( defined($element->GetSetAttr($attr)) ) {
            
            $cur_value = $element->GetSetAttr($attr);
            
            unless ($remove_old){
                $new = $cur_value.' '.$value;
            }
            
        }
        
        $element->GetSetAttr($attr,$new);
        
    }
    
    return $self;
    
}

#internal sub
sub GetSetAttr {
    my ($self, $key, $value) = @_;
    
    if (@_ == 3) {
        if (defined $value) {
            $self->setAttribute (lc $key, $value);
        } else {
            $self->removeAttribute(lc $key);
        }
    }
    
    else {
        return $self->getAttribute(lc $key);
    }
}

=head2 attr

=over 4

=item attr( attributeName )

Get the value of an attribute for the first element in the set of matched
elements.

=item attr( attributeName, value )

Set one or more attributes for the set of matched elements.

=item attr( map )

map: A hash ref of attribute-value pairs to set.

=item attr( attributeName, sub { my ( $index, $attr ) = @_; } )

=back


Check jQuery API

http://api.jquery.com/attr/

=cut

#tested
sub attr {
    
    my ($self,$attr,$value) = @_;
    
    ##if attr hash ref
    if (ref($attr) eq 'HASH'){
        while (my ($key,$val) = each(%{$attr})) {
            $self->editElement($key,$val,'remove old');
        }
    }
    
    elsif ($value){
        
        if (ref($value) eq 'CODE'){
            my $i = 0;
            $self->each(sub{
                my $i = shift;
                
                my $element = shift;
                my $val = &$value($i++,$element->GetSetAttr($attr));
                
                if ($val){
                    $element->GetSetAttr($attr,$val);
                }
                
            });
            
        }
        
        else {
            $self->editElement($attr,$value,'remove old');
        }
        
        return $self;
    }
    
    else {
        my $element = ($self->toArray)[0];
        
        if ($element){
            return $element->getAttribute($attr);
        }
        
        return '';
    }
    
}

=head2 removeAttr

Remove an attribute from each element in the set of matched elements.

Check jQuery API

http://api.jquery.com/removeAttr/

=cut

#tested
sub removeAttr {
    my $self = shift;
    my $attr = shift;
    
    foreach my $element ($self->toArray){
        $element->removeAttribute( $attr );
    }
    
    return $self;
    
}

=head2 addClass

Adds the specified class(es) to each of the set of matched elements.

=over 4

=item addClass( string )

One or more class names to be added to the class attribute of each matched
element.

=item addClass( sub { my ($this,$index,$currentClass) = @_; } )

A function returning one or more space-separated class names to be added.
Receives the index position of the element in the set and the old class value
as arguments.
    
=back

Check jQuery API

http://api.jquery.com/addClass/

=cut

#tested
sub addClass {
    
    my ($self,$new_class) = @_;
    
    
    if (ref($new_class) eq 'CODE'){
        
        $self->each(sub{
            my $i = shift;
            my $node = shift;
            my $return = &$new_class($i,$node->GetSetAttr('class'));
            
            if ($return){
                $node->editElement('class',$return);
            }
            
        });
    }
    
    else {
        $self->editElement('class',$new_class);
    }
    
    return $self;
    
}

=head2 removeClass

Remove a single class, multiple classes, or all classes from each element in
the set of matched elements.

=over 4

=item removeClass( string )

One or more space-separated classes to be removed from the class attribute of
each matched element

=item addClass( sub { my ($this,$index,$currentClass) = @_; } )

A function returning one or more space-separated class names to be removed.
Receives the index position of the element in the set and the old class value
as arguments.
    
=back

Check jQuery API

http://api.jquery.com/removeClass/

=cut


##tested
sub removeClass {
    
    my ($self,$class_name) = @_;
    
    if (ref $class_name eq 'CODE'){
        
        return $self->each(sub{
            
            my $i = shift;
            my $ele = shift;
            $ele->removeClass(  &$class_name($i,$ele->GetSetAttr('class'))    );
            
        });
        
    }
    
    if (!$class_name){
        $self->removeAttr('class');
    }
    
    else {
        
        my @classes = split (/ /, $class_name);
        
        foreach my $element ($self->toArray){
            
            my $cur_value;
            my @new;
            
            $cur_value = $element->GetSetAttr('class');
            
            foreach my $cur_class (split(/ /, $cur_value)){
                unless (grep{$cur_class eq $_}@classes){
                    push @new,$cur_class;
                } 
            }
            
            my $new = join(' ',@new);
            
            $element->GetSetAttr('class',$new);
            
        }
    }
    
    return $self;
    
}

=head2 toggleClass

Add or remove one or more classes from each element in the set of matched
elements, depending on either the class's presence or the value of the switch
argument.

=over 4

=item toggleClass( string )

One or more class names (separated by spaces) to be toggled for each element in
the matched set.

=item toggleClass( className, switch )

className: One or more class names (separated by spaces) to be toggled for each
element in the matched set.

switch: A boolean value to determine whether the class should be added or removed.

=item addClass( sub { my ($this,$index,$currentClass) = @_; }, switch )

A function returning one or more space-separated class names to be removed.
Receives the index position of the element in the set and the old class value
as arguments.

switch: A boolean value to determine whether the class should be added or removed.
    
=back

Check jQuery API

L<http://api.jquery.com/toggleClass/>

=cut

##tested
sub toggleClass {
    
    my ($this,$value,$stateVal) = @_;
    
    
    
    if ( ref $value eq 'CODE' ) {
	return $this->each( sub {
            my $i = shift;
            my $ele = shift;
	    this->toggleClass( &$value($i, $ele->GetSetAttr('class'), $stateVal), $stateVal );
	});
    }
    
    my $type = defined $value ? 1 : 0;
    my $isBool = defined $stateVal ? 1 : 0;
    
    return $this->each( sub {
	
        my $i = shift;
        my $ele = shift;
        
        if ( $type ) {
            
            #toggle individual class names
	    my $className;
	    
            
	    #my $self = jQuery( this );
	    my $state = $stateVal;
	    my @classNames = split (/ /, $value);
	    
            foreach my $className ( @classNames ) {
                
		#check each className given, space seperated list
		$state = $isBool ? $state : !$ele->hasClass($className);
		$state ? $ele->addClass( $className ) : $ele->removeClass( $className );
	    }
            
	} elsif (    !$type   ) {
            this->removeClass();
        }
        
        
    });
    
}

=head2 hasClass

Determine whether any of the matched elements are assigned the given class.

=over 4

=item hasClass( string )

String: The class name to search for.

=back

Check jQuery API

http://api.jquery.com/hasClass/

=cut

#tested
sub hasClass {
    
    my ($self,$has_class) = @_;
    
    #my $cur_value;
    #my $element = ($self->getNodes)[0];
    foreach my $element ($self->toArray){
        if ( defined $element && defined($element->GetSetAttr('class')) ) {
         
            my $cur_value = $element->GetSetAttr('class');
            
            foreach my $cur_class (split(/ /, $cur_value)){               
                if ($cur_class eq $has_class){
                    return 1;
                }        
            }      
        }
    }
    
    return 0;
}

sub toString {
    return shift->[0];
}

=head2 val

Get the current value of the first element in the set of matched elements.

=over 4

=item val()

Get the current value of the first element in the set of matched elements.

=item val( string )

Set the value of each element in the set of matched elements.

=item val( sub{ my ($this,$index,$value) = @_; } )

A function returning the value to set.
    
=back

Check jQuery API

http://api.jquery.com/val/

=cut

#tested
sub val(){
    
    my ($self,$content) = @_;
    
    if (@_ == 2){
        
        my $i;
        
        foreach my $element ($self->getNodes){
            
            $content = &$content($element,$i++,$element->val()) if ref($content) eq 'CODE';
           
            if ($element->nodeName eq "input" || $element->nodeName eq "select"){
                
                if ($element->exists('self::*[@type="text"]')){
                    $content = join(', ',@{$content}) if ref($content) eq 'ARRAY';
                    $element->GetSetAttr('value',$content);
                }
                
                else {
                    
                    if (!ref $content){$content = [$content]}
                    
                    if (ref($content) eq 'ARRAY'){
                        
                        if ($element->nodeName eq "select"){
                           
                            #get options
                            my @options = $element->findnodes('self::*/option');
                            
                            foreach my $option (@options){
                                
                                #$option->GetSetAttr('selected','selected'); 
                                if( ($option->hasAttribute('value') && grep{$option->GetSetAttr('value') eq $_}@{$content}) || (!$option->hasAttribute('value') && grep{ $option->findnodes('./text()')->string_value() eq $_}@{$content}) ){
                                    $option->GetSetAttr('selected','selected');
                                }
                                
                                else {
                                    $option->removeAttr('selected');
                                }
                            }
                            
                            
                        }
                        
                        elsif (grep{$element->exists('self::*[@value="'.$_.'"]')}@{$content}){
                            $element->GetSetAttr('checked','checked');
                        }
                    }
                    
                }
                
                
            }
            
            ##if textarea
            elsif ($element->nodeName eq "textarea"){
                $element->text($content);
            }
        }
        
        return $self;
    }
    
    
    else {
        my $node = ($self->toArray)[0];
        
        if (defined $node){
            
            
            if ($node->nodeName eq "input"){
                return $node->GetSetAttr('value');
            }
            
            ##if textarea
            elsif ($node->nodeName eq "textarea"){
                return $node->text();
            }
            
            ##this is a multi select element, return array of values
            elsif ($node->nodeName eq "select"){
                
                if ($node->hasAttribute('multiple')){
                    my @values;
                    
                    my @nodes = $node->findnodes('./option[@selected]');
                    foreach my $nd (@nodes){
                        push (@values,$nd->text());
                    }
                    return bless(\@values,$obj_class);
                }
                
                else {
                    return $node->findnodes('./option[@selected]')->string_value() || $node->findnodes('./option[1]')->string_value();
                }
                
            }
            
        }
    }
    
}


=head2 id

return element id

=cut
sub id {
    return shift->GetSetAttr('id');
}

=head2 find

Get the descendants of each element in the current set of matched elements,
filtered by a selector.

=over 4

=item find( selector )
    
=back

Check jQuery API

http://api.jquery.com/find/

=cut

{
no warnings 'redefine';
#XML::LibXML::Element::find();
*XML::LibXML::Element::find = \&find;
    sub find {
    
        my $self = shift;
        my $query = shift;
        my $custompath = shift;
        my @elements = ();
        #$self->pushStack([$query]);
        
        my @nodes = $self->this;
        
        if (ref $query){
            
            return jQuery( $query )->filter(sub {
                
                my $index = shift;
                my $this = shift;
                
                for ( my $i = 0; $i <= $#nodes; $i++ ) {
                    if ( $self->contains( $nodes[$i], $this ) ) {
			return 1;
		    }
		}
	    });
        }
        
        else {
            foreach my $node (@nodes){                
                push (@elements, $self->_find($query,$node))
            }
        }
        
        return $self->pushStack(@elements);
        
    };
}


=head2 css

insert css style(s) to the selected Element

=over 4

=item css({style=>value, style2 => value2, ...});

set list of hashref styles to the selected element(s)

=item css('style','value');

set one style to the selected element(s)
    
=back

=cut

#tested
sub css {
    
    my ($self,$options,$val) = @_;
    
    my $style;
    
    if (ref($options) eq 'HASH'){
        while ( my ($key, $value) = each(%{$options}) ) {
            $style .= $key.":".$value.";";
        }
    }
    
    elsif ($val){
        $style = $options.":".$val.";";
    }
    
    $self->editElement('style',$style) if $style;
    
    return $self;
}



#tested
my $THIS;

sub each {
    
    my ($self,$sub,$type) = @_;
    
    my @elements;
    
    my $i = 0;
    my $return = 0;
    
    
    my @nodes = $self->getNodes();
    
    #loop and bless each element
    foreach my $element (@nodes) {
        $THIS = $element;
        $return = &$sub($i++,$element);
        
        if ($type eq "map"){
            push (@elements,$return) if $return;
        }
        
        else {
            push (@elements,$element) if !$type || ($type && $return);
        }
        
    }
    
    return $self if $type eq 'nopush';
    
    return wantarray 
        ? @elements
        : $self->pushStack(@elements);
    
}

sub this {
    
    shift;
    my $self = shift;
    
    if (ref $self){
        return $self->toArray;
    }
    
    return $THIS;
}


=head2 data

Store arbitrary data associated with the specified element. Returns the value that was set.

=over 4

=item $obj->data( element, key, value )

or

=item $element->data( key, value )

element : The DOM element to associate with the data.

key : A string naming the piece of data to set.

value : The new data value.

=back

Check jQuery API

http://api.jquery.com/jQuery.data/

=cut

my $data = {};
sub data {
    my $element = shift;
    my ($self,$name,$value) = @_;
    
    if (ref $element =~ /jQuery/){
        $element = $self;
    }
    
    if ($value){
        $data->{$$element}->{$name} = $value;
    }
    
    return $data->{$$element}->{$name} || '';
    
}


=head2 filter

Reduce the set of matched elements to those that match the selector or pass the function's test.

=over 4

=item filter( selector )

=item filter( function )
    
=item filter( element )
    
=item filter( jQuery object )
    
=back

Check jQuery API

http://api.jquery.com/filter/

=cut

#tested, need some more tests
sub filter {
    
    my @elements;
    my ($self,$selector,$filter_type) = @_;
    
    
    
    my $i = 0;
    
    ##how I hack filter
    ##get new elements list of tree with the new selector
    ##then return duplicates
    my @new_nodes;
    
    
    my @old_nodes = $self->toArray;
    
    if (ref $selector eq 'CODE'){
        
        my @nodes = $self->each(sub {
            
            my $i = shift;
            my $this = shift;
            
            
            &$selector($i++,$this);
            
        },'filter');
        
        @new_nodes = @nodes;
        
    }
    
    else {
        
        @new_nodes = jQuery($selector,$self->document)->toArray;
        #return $self->pushStack(@new_nodes);
    }
    
    if ($filter_type eq 'reverse'){
        foreach my $od (@old_nodes){
            if ( !grep{ $$_ == $$od }@new_nodes ){
                push (@elements,$od);
            }
        }
    }
    
    else {
        my %dup = ();
        @elements = (@new_nodes,@old_nodes);
        @elements = grep {$dup{$$_}++} @elements;
    }
    
    return wantarray 
        ? @elements
        : $self->pushStack(@elements);
    
}


sub matchesSelector {
    
    my ($self,$element,$selector) = @_;
    
    my @nodeList = $element->parentNode->querySelectorAll($selector);
    #my @nodeList = $self->jQuery($selector)->getNodes;
    
    foreach my $node ( @nodeList ) {
        return 1 if $$node == $$element; 
    }
    
    return 0;
}

sub querySelectorAll {
    
    my ($self,$selector) = @_;
    
    #return $self->translate_query($selector,$self->nodePath);
    my @nodeList = $self->_find($selector,$self);
    
    return @nodeList;
    
}


=head2 map

Translate all items in an array or object to new array of items.

http://api.jquery.com/jQuery.map/

=cut
#tested
sub map {
    
    my ($self, $elems, $callback, $arg) = @_;
    
    if (ref($elems) eq 'CODE'){
        $arg = $callback;
        $callback = $elems;
        $elems = $self->toArray;
    }
    
    my @ret;
    my $value;
    my $i = 0;
    
    $self->each(sub{
        my $i = shift;
        $value = &$callback( $i, this, $arg );
	if ( $value ) {
            push(@ret,$value);
	}
        
    });

    my @flat;
    
    #flatten nested arrays
    foreach ( @ret ) {
        if (ref $_ eq 'ARRAY'){
            map { push @flat, $_ } @{$_};
        }
        else {
            push @flat,$_;
        }
    }
    
    return $self->pushStack(@flat);
}


=head2 html

=over 4

=item html()

Get the contents of any element. If the selector expression matches more than
one element, only the first one's HTML content is returned.

=item html( htmlString )

htmlString: A string of HTML to set as the content of each matched element.

=item html(sub {my ($this,$index,$oldhtml) = @_;} );

A CODE ref returning the HTML content to set. Receives element, the index
position of the element in the set and the old HTML value as arguments. jQuery
empties the element before calling the function; use the oldhtml argument to
reference the previous content.

same as jQuery .html( function(index, oldhtml) )
    
=back

Check jQuery API

http://api.jquery.com/html/

=cut

#tested
sub html {
    
    my ($self,$content) = @_;
    
    #return $content;
    
    if (ref $content eq 'CODE'){
        
        $self->each( sub {
            my $i = shift;
            my $ele = shift;
            $ele->html( &$content($i, $ele->html() ) );
	});
        
    }
    
    elsif (defined $content){
        
        ##create node
        my $i;
        my $nd;
        
        foreach my $element ($self->toArray) {
            $element->childNodes->remove();
            $element->append($content);
        }
        
    }
    
    else {
        
        my $nodeToGet = ($self->toArray)[0];
        
        if (defined $nodeToGet){
            my @childnodes = $nodeToGet->childNodes();
            my $html;
            
            foreach my $childnode (@childnodes){
                $html .= $childnode->serialize();
            }
            return $html;
            #return $self->decode_html($html);
        }
        
        else {
            return '';
        }
        
    }
    
    return $self;
    
}

=head2 text

=over 4

=item text()

The result of the text() method is a string containing the combined text of all
matched elements.

=item text( textString )

textString: A string of text to set as the content of each matched element.

=item text(sub { my ($index,$oldtext,$element) = @_;} );

A CODE ref returning the text content to set. Receives the element, index
position of the element in the set and the old text value as arguments.

same as jQuery .text( function(index, oldtext) )
    
=back

Check jQuery API

http://api.jquery.com/html/

=cut

#tested
sub text {
    
    my ($self,$text) = @_;
    
    
    if ( ref $text eq 'CODE' ) {
	return $self->each( sub {
            my $i = shift;
            my $ele = shift;
	    #var self = jQuery( this );
	    $ele->text( &$text($i, $ele->text() ) );
	});
    }
    
    if (defined $text){
        
        foreach my $element ($self->toArray) {
            $element->empty()->append( ($element && $element->ownerDocument || jQuery->document)->createTextNode( $text ) );
        }
        
    }
    
    else {
        
        foreach my $element ($self->toArray) {
            #$text .= bless($element, 'XML::LibXML::Text')->getData();
            $text .= $element->textContent();
        }
        
        return $text || '';
        
    }
    
    return $self;
    
}


sub empty {
    
    my $self = shift;
    
    foreach my $ele ($self->toArray){
        $ele->childNodes->remove();
    }
    
    return $self;
    
}



=head2 append

Insert content, specified by the parameter, to the end of each element in the
set of matched elements.

=over 4

=item append( content )

content: An element, HTML string, or jQuery object to insert at the end of each
element in the set of matched elements.

=item append( sub { my ($this,$index,$html) = @_; } )

A CODE ref that returns an HTML string to insert at the end of each element in
the set of matched elements. Receives the index position of the element in the
set and the old HTML value of the element as arguments.

same as jQuery .append( function(index, html) )
    
=back

Check jQuery API

http://api.jquery.com/append/

=cut

=head2 prepend

Insert content, specified by the parameter, to the beginning of each element in
the set of matched elements.

=over 4

=item prepend( content )

content: An element, HTML string, or jQuery object to insert at the beginning of
each element in the set of matched elements.

=item prepend( sub { my ($this,$index,$html) = @_; } )

A CODE ref that returns an HTML string to insert at the beginning of each
element in the set of matched elements. Receives the index position of the
element in the set and the old HTML value of the element as arguments.

same as jQuery .prepend( function(index, html) ) function
    
=back

Check jQuery API

http://api.jquery.com/prepend/

=cut

#tested
sub append { return shift->_pend(@_,'append'); }
sub prepend { return shift->_pend(@_,'prepend'); }

sub _pend {
    
    my ($self,$content,$content2,$method) = @_;
    
    if (!$method){
        $method = $content2;
        $content2 = undef;
    }
    
    
    
    if ( ref ($content) eq 'CODE' ){
        
        return $self->each(sub {
            my $i = shift;
            my $ele = shift;
            $self->$method( &$content( $i,$ele->html() ) );
        }); 
    }
    
    my @elements = $self->toArray;
    
    if ($content){
        
        ###get nodes to pend
        my $nodes = jQuery($content);
        
        foreach my $element (@elements) {
            
            #get element html content
            my $html = $element->html();
            
            my @clone = $nodes->clone();
            
            #map {$_->setOwnerDocument( $self->document  )} @$clone;
            
            @clone = reverse @clone if $method eq 'prepend';
            
            
            foreach my $nd (@clone){
                $element->appendChild($nd) if $method eq 'append';
                $element->insertBefore($nd,$element->firstChild()) if $method eq 'prepend';
            }
            
        }
        
        $nodes->remove();
        
    }
    
    if ($content2){
        return $self->$method($content2);
    }

    return $self;
    
}


=head2 appendTo

Insert every element in the set of matched elements to the end of the target.

=over 4

=item appendTo( Target )

Target: A selector, element, HTML string, or jQuery object; the matched set of
elements will be inserted at the end of the element(s) specified by this parameter.
    
=back

Check jQuery API http://api.jquery.com/appendTo/

=cut

=head2 prependTo

Insert every element in the set of matched elements to the beginning of the
target.

=over 4

=item prependTo( Target )

Target: A selector, element, HTML string, or jQuery object; the matched set of
elements will be inserted at the beginning of the element(s) specified by this
parameter.
    
=back

Check jQuery API

http://api.jquery.com/prependTo/

=cut

#tested
sub appendTo { return $_[0]->_pendTo($_[1],'appendTo'); }
sub prependTo { return $_[0]->_pendTo($_[1],'prependTo'); }

sub _pendTo {
    my ($self,$content,$method) = @_;
    
    my @elements = $self->toArray;
    my @target;
    
    
    my @nodes = jQuery($content)->toArray;
    
    my @new;
    
    foreach my $node (@nodes){
        @elements = reverse(@elements) if $method eq 'prependTo';
        foreach my $ele (@elements){
            my $copy = $ele->cloneNode(1);
            
            push @new,$copy;
            
            $node->appendChild($copy) if $method eq 'appendTo';
            $node->insertBefore($copy,$node->firstChild()) if $method eq 'prependTo';
        }
    }
    
    ##remove original
    foreach my $ele2 (@elements){
        $ele2->unbindNode();
    }
    
    return $self->pushStack(@new);
    
}

=head2 add

Add elements to the set of matched elements.

=over 4

=item add( selector )

selector: A string containing a selector expression to match additional
elements against.

=item add( selector, context )

selector: A string containing a selector expression to match additional
elements against.

context: Add some elements rooted against the specified context.
    
=item add( element )

elements: one or more elements to add to the set of matched elements.
    
=item add( <html> )

html: An HTML fragment to add to the set of matched elements.
    
=back

Check jQuery API

http://api.jquery.com/add/

=cut

#tested
sub add {
    my ( $self, $selector, $context ) = @_;
    
    my @set = jQuery($selector,$context)->toArray;
    my @all = jQuery::merge( [$self->toArray], [@set] );
    
    return $self->pushStack( @all );
}


sub add2 {
    my ( $self, $selector, $context ) = @_;
    
    my @set = !ref $selector ?
	jQuery( $selector, $context )->toArray :
	jQuery::makeArray( $selector && $selector->nodeType ? [ $selector ] : $selector )->toArray;
        
        my @all = jQuery::merge( [$self->this], [@set] );
    
    return $self->pushStack( jQuery::isDisconnected( $set[0] ) || jQuery::isDisconnected( $all[0] ) ?
	@all :
	jQuery::unique( @all ) );
}


=head2 andSelf

Add the previous set of elements on the stack to the current set.

Check jQuery API

http://api.jquery.com/andSelf/

=cut

#tested
sub andSelf {
return $_[0]->add( $_[0]->prevObject );
}

sub prevObject {
    return $_[0]->{prevObject};
}


=head2 next

Get the immediately following sibling of each element in the set of matched
elements. If a selector is provided, it retrieves the next sibling only if it
matches that selector.

=over 4

=item next( [ selector ] )
    
=back

Check jQuery API http://api.jquery.com/next/

=head2 nextAll

Get all following siblings of each element in the set of matched elements,
optionally filtered by a selector.

=over 4

=item nextAll( [ selector ] )
    
=back

Check jQuery API http://api.jquery.com/nextAll/

=head2 nextUntil

Get all following siblings of each element up to but not including the element
matched by the selector.

=over 4

=item nextUntil( [ selector ] )
    
=back

Check jQuery API http://api.jquery.com/nextUntil/

=head2 parent

Get the parent of each element in the current set of matched elements, optionally
filtered by a selector.

=over 4

=item parent( [ selector ] )
    
=back

Check jQuery API http://api.jquery.com/parent/


=cut

#tested
sub next { return $_[0]->_next($_[1],'next'); }
sub nextAll { return $_[0]->_next($_[1],'nextAll'); }
sub nextUntil { return shift->_next(@_,'nextUntil'); }

#tested
sub prev { return $_[0]->_next($_[1],'prev'); }
sub prevAll { return $_[0]->_next($_[1],'prevAll'); }
sub prevUntil { return shift->_next(@_,'prevUntil'); }

#tested
sub parent { return $_[0]->_next($_[1],'parent'); }
sub parents { return $_[0]->_next($_[1],'parents'); }
sub parentsUntil { return shift->_next(@_,'parentsUntil'); }

sub siblings { return $_[0]->_next($_[1],'siblings'); }


sub _next {
    
    my $self = shift;
    
    my ($selector,$filter,$type);
    
    if (@_ == 3){
        $selector = shift;
        $filter = shift;
        $type = shift;
    }
    
    else {
        $selector = shift;
        $type = shift;
    }
    
    
    my @new_elements;
    my @nodes = $self->toArray;
    my @elements;
    my @self;
    
    my $sibling = {
        next=>'following-sibling::*[1]',
        nextAll=>'following-sibling::*',
        nextUntil=>'self::*|following-sibling::*',
        prev => 'preceding-sibling::*[1]',
        prevAll=>'preceding-sibling::*',
        prevUntil=>'self::*|preceding-sibling::*',
        parent=>'parent::*',
        parents=>'ancestor::*',
        parentsUntil=>'ancestor-or-self::*',
        siblings=>'preceding-sibling::*|following-sibling::*'
    };
    
    my @qr;
    my @self_qr;
    
    foreach my $node (@nodes){
        #get queries
        my $path = $node->nodePath;
        
        foreach my $p (split(/\|/,$sibling->{$type})){
            push(@qr,$path."/".$p);
        }
        
        push(@self_qr,$path.'/self::*');
    }
    
    my $query = join(' | ',@qr);
    my $self_query = join(' | ',@self_qr);
    
    @elements = $self->document->findnodes($query);
    @self = $self->document->findnodes($self_query);
    
    
    ##from w3 - http://www.w3.org/TR/xpath/#predicates
    ##the ancestor, ancestor-or-self, preceding, and preceding-sibling axes are reverse axes; 
    ##but I don't know why this is giving in a forward order
    ##let's reverse them with perl
    if ($type =~ /^(prevUntil|parentsUntil|parents|prevAll|prev)$/){
        @elements = reverse @elements;
    }
    
    if ($selector){
        
        if ($type =~ /Until/){
            
            
            my @filter = jQuery($selector,$self->document)->toArray;
            
            ##get until element
            my $do = 0;
            
            foreach my $ele (@elements){
                
                if (!$do && grep{ $$_ == $$ele }@self) {
                    $do = 1;
                    next;
                }
                
                if (grep{ $$_ == $$ele }@filter ){
                    $do = 0;
                }
                
                push (@new_elements,$ele) if $do == 1;
            }
            
            if ($type eq 'prevUntil' || $type eq 'parentsUntil'){ @elements = reverse @new_elements; }
            else{ @elements = @new_elements; }
            
            return $self->pushStack(@elements)->filter($filter) if $filter;
        }
        
        else {
            return $self->pushStack(@elements)->filter($selector);
        }
        
    }
    
    return $self->pushStack(@elements);
}


=head2 children

Get the children of each element in the set of matched elements, optionally
filtered by a selector.

=over 4

=item children( [selector] )
    
=back

Check jQuery API

http://api.jquery.com/children/

=cut

#tested
sub children {
    
    my $self = shift;
    my $selector = shift || '*';
    
    return $self->find($selector);
    
}

=head2 closest

Get the first ancestor element that matches the selector, beginning at the
current element and progressing up through the DOM tree.

=over 4

=item closest( selector )

=item closest( selector, context )
    
=back

Check jQuery API

http://api.jquery.com/closest/

=cut


sub closest {
    
    my $self = shift;
    my $selector = shift;
    my $context = shift || $self->document;
    
    my @close_parent = ();
    
    my $parents = jQuery($selector,$context)->toArray;
    
    my @nodes = $self->toArray;
    
    foreach my $node (@nodes){
        
        ##get self and parents;
        my @parents = $node->findnodes('ancestor-or-self::*');
        
        foreach my $parent (reverse @{$parents}){
            if (grep{$$parent eq $$_}@parents){
                push(@close_parent,$parent);
                last;
            }
        }
        
    }
    
    return $self->pushStack(@close_parent);
    
}

=head2 contents

Get the children of each element in the set of matched elements, including text
and comment nodes.

=over 4

=item contents()
    
=back

Check jQuery API

<L:http://api.jquery.com/contents/>

=cut

sub contents {
    my $self  = shift;
    my $elem = shift;
    my @arr;
    $self->each(sub {
        push @arr, jQuery::makeArray( this->childNodes );
    });
    
    return $self->pushStack(@arr);
    
}

=head2 end

End the most recent filtering operation in the current chain and
return the set of matched elements to its previous state.

=over 4

=item end()
    
=back

Check jQuery API

http://api.jquery.com/end/

=cut

sub end {
    
    my $self = shift;
    return $self->pushStack( $self->prevObject() );
    
}

=head2 eq

Reduce the set of matched elements to the one at the specified index.

=over 4

=item eq( index )

=item eq( -index )
    
=back

Check jQuery API

http://api.jquery.com/eq/

=cut

sub eq {
    
    my $self = shift;
    my $index = shift;
    my @ele = $self->toArray;
    my @node = ($ele[$index]);
    #return \@node;
    return $self->pushStack(@node);
    
}


=head2 first

Reduce the set of matched elements to the first in the set.

=over 4

=item first( selector )
    
=back

Check jQuery API

http://api.jquery.com/first/

=cut

sub first {
    return $_[0]->eq('0');
}

=head2 last

Reduce the set of matched elements to the final one in the set.

Check jQuery API

http://api.jquery.com/last/

=cut

sub last {
    
    my $self = shift;
    my @ele = $self->getNodes;
    my @node = pop @ele;
    return $self->pushStack(@node);
}

=head2 has

Reduce the set of matched elements to those that have a descendant that matches
the selector or DOM element.

=over 4

=item has( selector )

=item has( contained )
    
=back

Check jQuery API

http://api.jquery.com/has/

=cut
sub has {
    
    my @elements;
    my ($self,$selector) = @_;
    
    my @nodes;
    

    my $nodes = jQuery($selector);
    
    return $self->filter(sub{
        my $this = shift;
        my $index = shift;
        foreach my $nd (@{$nodes}){
            if ($self->contains($this,$nd)){
                return 1;
            }
        }
    });

    return $self->pushStack(@nodes);
}

=head2 contains

=cut
sub contains {
    my $self = shift;
    my $container = shift;
    my $contained = shift;
    
    
    #not sure why this didnt work
    #return $container->exists( $contained->nodePath );
    
    my @childs = $container->findnodes('descendant::*');
    #return \@childs;
    
    foreach my $child (@childs){
        return 1 if $$contained == $$child;
    }
    
    return 0;
    
}

=head2 is

Check the current matched set of elements against a selector
and return true if at least one of these elements matches the selector.

=over 4

=item is( selector )
    
=back

Check jQuery API

http://api.jquery.com/is/

=cut

sub is {
    
    my $self = shift;
    my $selector = shift;
    
    return $selector && $self->filter($selector)->length > 0;
    
}






=head2 not

Remove elements from the set of matched elements.

=over 4

=item not( selector )

=item not( function )
    
=item not( element )
    
=item not( jQuery object )
    
=back

Check jQuery API http://api.jquery.com/not/

=cut

sub not  {
    my $self = shift;
    my $content = shift;
    return $self->filter($content,'reverse');
}

sub slice  {
    
    my ($self,$start,$end) = @_;
    my @nodes = $self->getNodes();
    my @elements;
    if ($end){
        $end = $end-$start;
        @elements = splice(@nodes,$start,$end); 
    }
    else{ @elements = splice(@nodes,$start); }
    return $self->pushStack(@elements);
}



######DOM Insertion, Around........ warp(), unrap(), wrapall(), wrapinner()
##couldn't figure out how to do this my self so I copied it from jquery.js :P

=head2 replaceWith

=cut
sub replaceWith {
    my $self = shift;
    my $selector = shift;
    my $value = $selector;
    
    #return $selector;
    
    my $nodes = jQuery($selector);
    
    if ( ref $selector eq 'CODE' ) {
	return $self->each( sub {
            
            my $i = shift;
            my $this = shift;
            
	    my $self2 = $self->jQuery($this);
            
            my $old = $self2->html();
	    
            $self2->replaceWith( &$selector( $i, $this, $old ) );
            
	});
    }
    
    $value = $nodes->detach();
   
    
    $self->each( sub {
        shift;
        my $this = shift;
        
	my $next = $this->nextSibling;
	my $parent = $this->parentNode;
        
        $this->remove();
        
        if ( $next ) {
	    $next->before($value);
	}
        
        else {
	    $parent->append($value);
	}
        
    },'nopush');
    
}

=head2 wrap

=cut
sub wrap {
    
    my $self = shift;
    my $selector = shift;
    
    return $self->each( sub {
        shift;
        my $this = shift;
	$this->wrapAll( $selector );
    });
    
    #return $self->pushStack(@m);

}

=head2 unwrap

=cut
sub unwrap {
    my $self = shift;
    
    my $t = $self;
    
    return $self->parent->each( sub {
        shift;
        my $this = shift;
	if ( $this->nodeName ne 'body') {
            my $childs = $this->childNodes;
	    $self->jQuery($this)->replaceWith( $childs );
	}
        
    },'nopush')->end();
    
}


=head2 wrapInner

=cut
sub wrapInner {
    my ( $this,$html ) = @_;
    
    
    if ( ref $html eq 'CODE' ) {
	return $this->each(sub{
            my $i = shift;
            my $this = shift;
            jQuery($this)->wrapInner( &$html($i,$this) );
        });
    }

    return $this->each( sub {
	my $self = jQuery( $this );
	my $contents = $self->contents();
        
	if ( jQuery::_length($contents) ) {
            $contents->wrapAll( $html );
        } else {
            $self->append( html );
	}
    });

}


#I think mine is better than the real jQuery one :P
=head2 wrapAll

=cut
sub wrapAll {
    
    my $self = shift;
    my $content = shift;
    
    ##create new node
    my $ele;
    my $return;
    my $to_append;
    my $i = 0;
    my $parent_node;
    
    my @nodes = $self->getNodes;
    
    my $append = jQuery($content);
    
    if (!$append){
        return $self;
    }
    
    if (ref $content eq 'CODE' ) {
	return $self->each( sub {
            my $i = shift;
            my $this = shift;
	    $this->wrapAll( &$content($i,$this) );
	});
    }
    
    my @clone = $append->clone('1');
    $parent_node = $clone[0];
    
    $to_append = $parent_node->findnodes('descendant-or-self::*[last()]')->[0];
    
    if (!$to_append){
        return $self;
    }
    
    my @new_nodes;
    
    foreach my $node (@nodes){
        
        my $old_node = $node->cloneNode('1');
        push(@new_nodes,$old_node);
        
        
        $to_append->appendChild($old_node);
        
        $node->unbindNode() if $i > 0;
        $i++;
        
    }
    
    return $self if !@nodes;
    
    $nodes[0]->replaceNode($parent_node);
    return $self->pushStack(@new_nodes);
    
}

=head2 after

=cut
=head2 before

=cut
=head2 insertBefore

=cut
=head2 insertAfter

=cut
sub after {return $_[0]->_beforeAfter($_[1],'after');}
sub before {return $_[0]->_beforeAfter($_[1],'before');}
sub insertBefore {return $_[0]->_beforeAfter($_[1],'insertBefore');}
sub insertAfter {return $_[0]->_beforeAfter($_[1],'insertAfter');}

sub _beforeAfter {
    
    my ($this,$html,$insert_type) = @_;
    
    $insert_type ||= 'after';
    
    return $this if !$html;
    
    if ( ref $html eq 'CODE' ) {
	return $insert_type eq 'insertBefore' || $insert_type eq 'insertAfter' ?
        $this :
        $this->each(sub{
            my $i = shift;
            my $this = shift;
            
            my $t = &$html($i,$this);
            return if !$t;
            jQuery($this)->$insert_type( $t );
        });
    }
    
    my $self;
    
    
    my $action = {
        after => 'insertAfter',
        before => 'insertBefore',
        insertBefore => sub {
            $self = $this;
            $this = jQuery( $html );
            return 'insertBefore';
        },
        insertAfter => sub {
            $self = $this;
            $this = jQuery( $html );
            return 'insertAfter';
        },
    };
    
    my $insert = $action->{$insert_type};
    
    if (ref $insert eq 'CODE'){
        $insert = $insert->();
    }
    
    else {
        $self = jQuery( $html );
    }
    
    my @m;
    
    foreach my $node (@{$this->toArray}){
        
        my @nd = $self->clone('1');
        @nd = reverse @nd if $insert_type eq 'after' || $insert_type eq 'insertAfter';
        
        push @m,@nd;
        
        foreach my $nd (@nd){
            $node->parentNode->$insert($nd,$node);
        }
        
    };
    
    #remove previous cloned object
    $self->remove();
    return $this->pushStack(@m);
}


sub getNode {
    my ($this,$num) = @_;
    return $this->toArray->[$num];
}

=head2 clone

=cut
sub clone {
    my ($self,) = @_;

    my @cloned;
    my @nodes = $self->getNodes;
    
    return bless([], $base_class) if !@nodes;
    
    #my $origdoc = $nodes[0]->ownerDocument;
    #my $origdoc = $self->document->ownerDocument;
    #my $doc = XML::LibXML::Document->new($origdoc->version, $origdoc->encoding);
    
    foreach my $node (@nodes){
        my $clone = $node->cloneNode('1');
        #$origdoc->setDocumentElement($node);
        #$self->document->setDocumentElement($clone);
        push(@cloned, $clone);
    }
    
    #return bless(\@cloned,$obj_class);
    return wantarray ? @cloned
    : $self->pushStack(@cloned);

}



###load, post, get functions
### FIXME - should rewrite this!!!
sub get {
    my ( $self, $url, $data, $callback, $type ) = @_;
    
    ##get node, not Ajax function
    if ($url =~ /\d+/){
        return $self->getNode($url);
    }
    
    elsif (!$url){
        return $self;
    }
    
    #shift arguments if data argument was omited
    if ( ref( $data ) eq 'CODE' ) {
	$type = $type || $callback;
	$callback = $data;
	$data = undef;
    }
    
    return $self->ajax({
	type => "GET",
	url => $url,
	data => $data,
	success => $callback,
	dataType => $type
    });
}



sub post {
    
    my ( $self, $url, $data, $callback, $type ) = @_;
    
    #shift arguments if data argument was omited
    if ( ref( $data ) eq 'CODE' ) {
	$type = $type || $callback;
	$callback = $data;
	$data = undef;
    }

    return $self->ajax({
	type => "POST",
	url => $url,
	data => $data,
	success => $callback,
	dataType => $type
    });
}


sub ajax {
    my ( $self, $options ) = @_;
    
    my $type = uc($options->{type}) || 'GET';
    my $beforeSend = $options->{beforeSend} || undef;
    my $success = $options->{success} || undef;
    my $context = $options->{context} || $self;
    my $timeout = $options->{timeout} || '300';
    my $agent = $options->{agent} || 'Perl-jQuery';
    my $data = $options->{data} || undef;
    my $contentType = $options->{contentType} || 'application/x-www-form-urlencoded';
    
    my $cache = $options->{cache} || undef;
    
    my $ua = new LWP::UserAgent(timeout => $timeout);

    $ua->agent($agent);
    
    my $req;

    if ($type eq 'POST'){
        $req = HTTP::Request->new( POST, $options->{url});
        $req = HTTP::Request::Common::POST($options->{url},Content=>$data);
    }
    
    else {
        
        $req = HTTP::Request->new();
        
        $req->uri( $options->{url} );
        
        if ($data){
            my $query = $req->uri->query;
            $req->uri->query_form( $data );
        }
    }
    
    $req->method($type);
    $req->content_type($contentType);
    
    ##excute beforeSend function
    if ($beforeSend){
        &$beforeSend($req);
    }
    
    ##send request
    my $response = $ua->request($req);
    my $content = $response->content;
    
    ###excute success function
    if ($success){
        #my @arg = ($content);
        #push (@arg,$context) if $options->{context};
        &$success($content);
    }
    
    #return $self->jQuery($content);
    return $content;
    
}


=head2 length

returns number of matched elements

=cut

sub length {
    return scalar $_[0]->getNodes;
}

sub detach {
    
    my $self = shift;
    my $selector = shift;
    return $self->remove($selector,'true');
    
}

=head2 remove

=cut
sub remove {
    
    my $self = shift;
    my $selector = shift;
    my $keepdata = shift;
    my @elements;
    my $elements;
    
    if ($selector){
        @elements = $self->filter($selector);
    }
    
    else {
        $elements = jQuery($self)->toArray;
    }
    
    foreach my $element (@{$elements}){
        $element->unbindNode();
    }
    
    #return jQuery($self);
    return $self->pushStack($elements) if $keepdata;
    return $self->pushStack([]);
}


sub join {
    my ($self,$char) = @_;
    return join($char,$self->getNodes);
}




1;