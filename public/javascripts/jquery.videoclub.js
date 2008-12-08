
(function($) {

    if (typeof(console) == 'undefined' || typeof(console.log)  == 'undefined') {
        console = {
            log : function() {}
        };
    }

    String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g,'')
    }

    var validations = {
        not_empty : function(callback) {
            var value = $(this).val();
            if (value.trim().length == 0) {
                callback.apply(null, []);
            }
        },
        integer : function (callback) {
            var regexp = /^\d*$/;
            if (!regexp.test($(this).val())) {
                callback.apply(null, []);
            }
        },
        price : function(callback) {
            var value = parseInt($(this).val());
            if (value <= 60) {
                callback.apply(null, []);
            }
        }
    };

    $.fn.validate = function(method_name) {
        var curried = [];
        for ( var i = 1; i < arguments.length; i++) {
            curried.push(arguments[i]);
        }
        return this.each(function() {
            var method = validations[method_name];
            if (method != null) {
                console.log("validate " + method_name);
                method.apply(this, curried);
            } else {
                curried[0].apply(null, []);
            }
            return false;
        });
    };
})(jQuery);

