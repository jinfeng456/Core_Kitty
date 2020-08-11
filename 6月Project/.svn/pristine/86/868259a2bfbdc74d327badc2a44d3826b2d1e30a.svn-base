export function printSelected(preHtml, preTable, endTable, endHtml, endLine, preLine) {
    var ele = $(this);
    //var printLength = $(ele).find('thead>tr>th[isPrint="1"]').length;//需要打印的字段个数
    var idPrefix = "printArea";
    var iframeId = idPrefix + '_' + this.id;
    var iframeStyle = 'position:absolute;width:0px;height:0px;left:-500px;top:-500px;';
    var iframe = document.getElementById(iframeId);
    if (iframe == null) {
        iframe = document.createElement('IFRAME');
        $(iframe).attr({
            style: iframeStyle,
            id: iframeId
        });
        document.body.appendChild(iframe);
    }
    //样式
    var link = '<style type="text/css">.print-table {border-collapse: collapse;font-size: 8px;width:100%;}';
    link += '.print-table-td {border: 0.5px solid black;}';
    link += '</style>';
    var buildTable = preHtml + preTable + '<table class="print-table">';
    buildTable += '<tbody>';
    buildTable += preLine;
    buildTable += '<tr><td class="print-table-td">序号</td>';
    var printIndexMap = new Map();
    var totalIndexMap = new Map();
    var thIndex = 0;
    var thArray = [];
    var theadCols = $(ele).find('thead>tr>th');
    theadCols.each(function () {
        if ($(this).attr("isPrint") === "1") {
            printIndexMap.put(thIndex, $(this).attr("order"));
            if ($(this).attr("isTotal")) totalIndexMap.put(thIndex, $(this).attr("isTotal"));//需要总计的列
            //对字段显示进行排序
            var thHtml = '<td class="print-table-td">' + $(this).text() + '</td>';
            thArray[$(this).attr("order")] = thHtml;
        }
        thIndex++;
    });
    buildTable += thArray.join("");
    buildTable += '</tr>';
    var tr = $(ele).find('tbody>tr');
    var totalValueArray = [];
    var rowIndex = 1;//序号
    tr.each(function () {
        if ($(this).find(".ck_child:checked").length === 1) {
            buildTable += '<tr><td class="print-table-td">' + rowIndex++ + '</td>';
            var td = $(this).find('td');
            var tdIndex = 0;
            var tdArray = [];
            td.each(function () {
                if (printIndexMap.containsKey(tdIndex)) {
                    //对字段显示进行排序
                    var tdHtml = '<td class="print-table-td">' + $(this).text() + '</td>';
                    var totalIndex = totalIndexMap.get(tdIndex);
                    if (totalIndex) {
                        if (!totalValueArray[totalIndexMap.get(tdIndex) - 1]) totalValueArray[totalIndexMap.get(tdIndex) - 1] = 0;
                        totalValueArray[totalIndexMap.get(tdIndex) - 1] += parseFloat(parseFloat($(this).text()).toFixed(2));
                    }
                    tdArray[printIndexMap.get(tdIndex)] = tdHtml;
                }
                tdIndex++;
            });

            buildTable += tdArray.join("");
            buildTable += '</tr>';
        }
    });
    if ($(ele).find('thead>tr>th[isTotal]').length > 0) {
        $.each($(ele).find('thead>tr>th[isTotal]'), function (i, value) {
            buildTable += endLine.replace(('totalValue' + (i + 1)), totalValueArray[i]);
        });
    }
    buildTable += '</tbody>';
    buildTable += '</table>';
    buildTable += endTable;
    buildTable += endHtml;
    console.info(buildTable);
    iframe.contentWindow.document.body.innerHTML = '<html style="height: 100%;width:100%"><head>' + link + '</head><body>' + buildTable + '</body></html>';
    iframe.contentWindow.focus();
    iframe.contentWindow.print();
}


export function printMoudle(html) {   
    var iframeId = "frameId";
    var iframeStyle = 'position:absolute;width:0px;height:0px;left:-500px;top:-500px;';
    var iframe = document.getElementById(iframeId);
    if (iframe == null) {
        iframe = document.createElement('IFRAME');
        $(iframe).attr({
            style: iframeStyle,
            id: iframeId,
            srcdoc:html
        });
        document.body.appendChild(iframe);
    }  
    iframe.contentWindow.focus();
    iframe.contentWindow.print();
}