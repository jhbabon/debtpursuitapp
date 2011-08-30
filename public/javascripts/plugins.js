// place any jQuery/helper plugins in here, instead of separate, slower script files.

;(function( $ ) {

  var settings = {
    addLink:          'a[data-expense-add]',
    attributeKey:     '[data-expense-attribute]',
    inputNamePrefix:  'expenses[]'
  };

  var methods = {
    init: function() {
      var plugged = $( this );
      plugged.delegate( settings.addLink, 'click', function() {
        plugged.expendable( 'add', { targetId: $( this ).data( 'targetId' ) } );
        return false;
      });
    },

    add:  function( options ) {
      var plugged = $( this );
      var target  = $( '#' + options.targetId );

      plugged.find( settings.attributeKey ).each( function( index, attribute ) {
        var input = _secrets.input( attribute );
        var info  = _secrets.info( attribute );

        target.append( input );
        target.append( info );
      });
    }
  };

  var _secrets = {
    input: function( attribute ) {
      var value = $( attribute ).val();
      var name  = $( attribute ).attr( 'name' );
      var input = $( '<input>', {
        type:   'hidden',
        value:  value,
        name:   settings.inputNamePrefix + '[' + name + ']'
      });

      return input;
    },

    info: function( attribute ) {
      return '<p>' + $( attribute ).val() + '</p>';
    }
  };

  $.fn.expendable = function( method ) {
    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || !method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.expendable' );
    };
  };

})( jQuery );
