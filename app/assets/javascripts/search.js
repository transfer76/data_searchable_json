jQuery(document).ready(function() {
    var blank;
    blank = function() {
        $('#results').empty().append('<li>Nothing data found</li>');
        return false;
    };
    return $(document).on('submit', '#search_form', function(e) {
        var query, url;
        e.preventDefault();
        query = $('#query').val();
        url = $(this).data('url');
        if (query === '' || url === '') {
            return false;
        }
        $.ajax({
            url: url,
            type: 'GET',
            data: {
                query: query
            },
            dataType: 'json',
            success: function(data) {
                var $res, i, row, len, results;
                if (!(data && data.length)) {
                    return blank();
                }
                $res = $('#results');
                $res.html('');
                results = [];
                for (i = 0, len = data.length; i < len; i++) {
                    row = data[i];
                    results.push($res.append("<li>\n <p><b>Lang Name:  </b>" + row['Name'] + " </p>\n </li>\n <li>\n <p>" +
                        "<b>Type: </b>" + row['Type'] + "</p>\n </li>\n <li>\n <p><b>Designed by:  </b>" + row['Designed by'] + "</p>\n " +
                        "<p>----------------------------------------------------</p>\n </li>"));
                }
                return results;
            }
        });
        return false;
    });
});