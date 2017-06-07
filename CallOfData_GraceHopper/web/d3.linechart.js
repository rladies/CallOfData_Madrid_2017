function LineChartDate() {
    var margin = {top: 10, right: 10, bottom: 20, left: 80},
        width = 960 - margin.left - margin.right,
        height = 350 - margin.top - margin.bottom,
        yvalue = 'values',
        xvalue = 'date',
        dateformat = '%Y-%m-%d', // https://github.com/d3/d3-time-format/blob/master/README.md#locale_format
        colorScale = d3.scaleOrdinal(d3.schemeCategory20c),
        ydomain = 'extent', // [extent,0max,min0]
        curve = false; // [curveLinear,curveStep,curveStepBefore,curveStepAfter,curveBasis,curveCardinal,curveMonotoneX,curveCatmullRom]


    function chart(selection) {

        var parseTime = d3.timeParse(dateformat),
            xScale = d3.scaleTime().rangeRound([0, width]),
            yScale = d3.scaleLinear().rangeRound([height, 0]);

        var bisectDate = d3.bisector(function(d) { return d[xvalue]; }).left

        var line = d3.line()
            .x(function(d) { return xScale(d.x); })
            .y(function(d) { return yScale(d.y); });

        selection.each(function(data) {

            if(curve) line.curve(d3.curveBasis);

            // Generate transpose matrix for y values
            var dataT = [];
            yvalue.forEach(function(j,i){
                dataT[i] = {}
                dataT[i]['key'] = j
                dataT[i]['values'] = []
            });

            data.forEach(function(d){
                d[xvalue] = parseTime(d[xvalue]);
                d.min =  9999999999;
                d.max = -9999999999;
                yvalue.forEach(function(j, i){
                    dataT[i]['values'].push({'x': d[xvalue], 'y': +d[j]})
                    if (d[j] < d.min) d.min = +d[j];
                    if (d[j] > d.max) d.max = +d[j];
                })
            });

            // Domains
            xScale.domain(d3.extent(data, function(d) { return d[xvalue]; }));

            if(ydomain == 'extent'){
                yScale.domain([d3.min(data, function(d) { return d.min;}), d3.max(data, function(d) { return d.max;})]);
            }else if (ydomain == 'min0'){
                yScale.domain([d3.min(data, function(d) { return d.min;}), 0]);
            }else{
                yScale.domain([0, d3.max(data, function(d) { return d.max;})]);
            }

            var svg = d3.select(this)
                .append('svg')
                .attr("class", "chart linechart linechart--simple")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom);

            var g = svg.append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

            g.append("g")
                .attr("class", "axis axis--x")
                .attr("transform", "translate(0," + height + ")")
                .call(d3.axisBottom(xScale));

            g.append("g")
                .attr("class", "axis axis--y")
                .call(d3.axisLeft(yScale));
                /*
                .append("text")
                .attr("transform", "rotate(-90)")
                .attr("y", 6)
                .attr("dy", "0.71em")
                .attr("fill", "#000")
                .text("Temperature, ºF");
                */


            var lineg = g.selectAll(".lineg")
                .data(dataT)
                .enter().append('g')
                .attr("class", "lineg");

            var linepath = lineg.append('path')
                .attr("class", "line")
                .style('stroke', function(d, i){ return colorScale(i); })
                .attr("d", function(d) {
                    return line(d.values);
                });
        });
    }


    chart.width = function(value) {
        if (!arguments.length) {
            return width;
        }
        if (typeof value == 'string') {
            width = parseInt(d3.select(value).style('width'), 10) - margin.left - margin.right;
        } else {
            width = value - margin.left - margin.right;
        }
        return chart;
    };

    chart.height = function(value) {
        if (!arguments.length) {
            return height;
        }
        if (typeof value == 'string') {
            height = parseInt(d3.select(value).style('height'), 10) - margin.top - margin.bottom;
        } else {
            height = value - margin.top - margin.bottom;
        }
        return chart;
    };

    chart.yvalue = function(value) {
        if (!arguments.length) {
            return yvalue;
        } else {
            if(typeof value == 'string') yvalue = [value];
            else if(Array.isArray(value)) yvalue = value;
            else return yvalue;
        }
        return chart;
    };

    chart.xvalue = function(value) {
        if (!arguments.length || typeof value != 'string') {
            return xvalue;
        } else {
            xvalue = value;
        }
        return chart;
    };

    chart.dateformat = function(value) {
        if (!arguments.length || typeof value != 'string') {
            return dateformat;
        } else {
            dateformat = value;
        }
        return chart;
    };

    chart.ydomain = function(value) {
        if (!arguments.length || typeof value != 'string') {
            return ydomain;
        } else {
            ydomain = value;
        }
        return chart;
    };

    chart.colors = function(value) {
        if (!arguments.length || !Array.isArray(value)) {
            return colorScale;
        } else {
            colorScale = d3.scaleOrdinal().range(value);
        }
        return chart;
    };

    chart.curve = function(value) {
        if (!arguments.length || typeof value != 'string') {
            return curve;
        } else {
            curve = value;
        }
        return chart;
    };

    return chart;
}