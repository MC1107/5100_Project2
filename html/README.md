<p><b>Open the lab2_4.html</b></p>

<p>Click the bubble to open the video.</p>
<p>Move the mouse over the bubble to see the title of the talk.</p>
<p>Click the Sunburst to select the disciplines and shrink the bubbles.</p>
<p>Click the center of the Sunburst to get a recommendation randomly.</p>


<img src="./version1.png">
<img src="./version2.png">
<img src="./version3.png">

<!DOCTYPE html>
<meta charset="utf-8">
<title>Clustered Force Layout</title>
<head>
  <script src="//d3js.org/d3.v4.min.js"></script>
  <style>
  /*svg { border: solid #ccc 1px;  }*/
  h1 {
    font: 80px "Helvetica Neue";
    color: white;
    text-align: center;
    width: 960px;
    height: 500px;
    margin: 0;
  }

  div.tooltip {
    position: absolute;
    text-align: left;
    width: 200px;
    height: 50px;
    padding: 2px;
    font: 12px sans-serif;
    color: white;
    background: black;
    border: 0px;
    border-radius: 8px;
    pointer-events: none;
  }

  body {
      background-color: black;
      font-family: Sans-serif;
      font-size: 13px;
  }

  .slice {
      cursor: pointer;
  }

  .slice .main-arc {
      stroke: #000;
      stroke-width: 5px;
  }

  .slice .hidden-arc {
      fill: none;
  }

  .slice text {
      pointer-events: none;
      dominant-baseline: middle;
      text-anchor: middle;
  }
  </style>  
</head>

<body>
<script>

    var widthDot = window.innerWidth;
    var heightDot = window.innerHeight;
    var maxRadiusDot = 15;
    var minRadiusDot = 6;

    var svg = d3.select("body").append("svg")
                .attr("width", widthDot)
                .attr("height", heightDot)
                .append('g').attr('transform', 'translate(' + widthDot / 2 + ',' + heightDot / 2 + ')')
                .on('click', () => focusOn());



    
    // for sunburst
    const width = 400,
            height = 400,
            maxRadius = (Math.min(width, height) / 2) - 5;

    const formatNumber = d3.format(',d');

    const xScaler = d3.scaleLinear()
        .range([0, 2 * Math.PI])
        .clamp(true);

    const yScaler = d3.scaleSqrt()
        .range([maxRadius*.1, maxRadius]);

    // const color = d3.scaleOrdinal(d3.schemeCategory20);
    var color = d3.scaleOrdinal()
  // .domain(myData)
  .range(['#FF2400', '#ED2939', '#C21807']);

    const partition = d3.partition();

    const arc = d3.arc()
        .startAngle(d => xScaler(d.x0))
        .endAngle(d => xScaler(d.x1))
        .innerRadius(d => Math.max(0, yScaler(d.y0)))
        .outerRadius(d => Math.max(0, yScaler(d.y1)));

    const middleArcLine = d => {
      const halfPi = Math.PI/2;
      const angles = [xScaler(d.x0) - halfPi, xScaler(d.x1) - halfPi];
      const r = Math.max(0, (yScaler(d.y0) + yScaler(d.y1)) / 2);

      const middleAngle = (angles[1] + angles[0]) / 2;
      const invertDirection = middleAngle > 0 && middleAngle < Math.PI; // On lower quadrants write text ccw
      if (invertDirection) { angles.reverse(); }

      const path = d3.path();
      path.arc(0, 0, r, angles[0], angles[1], invertDirection);
      return path.toString();
    };

    const textFits = d => {
        const CHAR_SPACE = 6;

        const deltaAngle = xScaler(d.x1) - xScaler(d.x0);
        const r = Math.max(0, (yScaler(d.y0) + yScaler(d.y1)) / 2);
        const perimeter = r * deltaAngle;

        return d.data.name.length * CHAR_SPACE < perimeter;
    };


//end sunburst


var m = 1; // number of distinct clusters

var colorDot = d3.scaleOrdinal(d3.schemeCategory20)
    .domain(d3.range(m));

// The largest node for each cluster.
var clusters = new Array(m);



  var div = d3.select("body").append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);


// function parseLine (line) {
//   return { title: line["title"]};
// }

function getX() {
  var seedX = Math.floor(Math.random() * widthDot) - widthDot / 2;
  if(seedX < 200 && seedX > 0) seedX += 200;
  else if (seedX > -200 && seedX < 0) seedX -= 200;

  return seedX;
}

function getY() {
  var seedY = Math.floor(Math.random() * heightDot) - heightDot / 2;
  if(seedY < 200 && seedY > 0) seedY += 200;
  else if (seedY > -200 && seedY < 0) seedY -= 200;

  return seedY;

}

function get() {
  var seed = (Math.random() * 360);
  var array = [];
  var x = 800 * Math.cos(seed);
  var y = 800 * Math.sin(seed);
  array.push(x);
  array.push(y);
  return array;
}

function getY() {
  var seedY = Math.floor(Math.random() * heightDot) - heightDot / 2;
  if(seedY < 200 && seedY > 0) seedY += 200;
  else if (seedY > -200 && seedY < 0) seedY -= 200;

  return seedY;

}

 // function switchRadius(newRadius) {
 //   return function() {
 //     d3.selectAll('circle')
 //        .filter(function(d,i) { return i === 5; })
 //        .transition().duration(1000)
 //        .tween('r', function(d) {
 //          var that = d3.select(this);
 //          var i = d3.interpolate(d.r, newRadius);
 //          return function(t) {
 //            d.radius = i(t);
 //            that.attr('r', function(d) { return d.r; });
 //            force.nodes(nodes)
 //          }
 //        });
 //     force.alpha(1).restart();
 //   }
 // }

function openInNewTab(url) {
  var win = window.open(url, '_blank');
  win.focus();
}

function empty() {

}
// function updateHSL(node,h,s,l) {
//   node.h = h;
//   node.s = s;
//   node.l = l;
// }



// svg.append('button').text('grow')
//   .on('click', switchRadius(100));

// svg.append('button').text('shrink')
//   .on('click', switchRadius(10));


d3.queue()
.defer(d3.csv, "ted_final.csv")
.defer(d3.json, "dicipline1.json")
.defer(d3.csv, "discipline.csv")
.defer(d3.json, "1.json")
.await(callback);

function callback (error, _ted_main1000, root,discipline, sourse) {



  var nodes = _ted_main1000;
  // console.log(root);
  var rootVar = {};
  nodes.unshift(rootVar);



  // preprocess the data

  var dis = discipline;
  console.log(dis);
  var sou = sourse;
  sou.forEach(function(d,i){
      var temp = d.tags.split(', ');
      d.tags = temp;
  });
  console.log(sou);
  sou.forEach(function(d,i){
      var temp = d;
      // var array1 = [];
      // var array2 = [];
      var array2 = [0,0,0,0,0,0];
      var array1 = [0,0];
      var array3 = [];
      for (var i = 0; i < 19; i++) {
          var tep = {"val":0,"root1":0,"root2":0};
          array3.push(tep);
      }
      for (var j = 0; j < d.tags.length; j++) {
          dis.forEach(function(d,i){
              if(d.tags.indexOf(temp.tags[j])>=0) {array3[i].val++; }
          });
      }
      array3[0].root1 = 0;
      array3[0].root2 = 0;

      array3[1].root1 = 0;
      array3[1].root2 = 0;

      array3[2].root1 = 0;
      array3[2].root2 = 2;

      array3[3].root1 = 0;
      array3[3].root2 = 1;

      array3[4].root1 = 0;
      array3[4].root2 = 1;

      array3[5].root1 = 0;
      array3[5].root2 = 1;

      array3[6].root1 = 0;
      array3[6].root2 = 2;

      array3[7].root1 = 0;
      array3[7].root2 = 2;

      array3[8].root1 = 0;
      array3[8].root2 = 2;

      array3[9].root1 = 0;
      array3[9].root2 = 2;

      array3[10].root1 = 0;
      array3[10].root2 = 2; 
      
      array3[11].root1 = 1;
      array3[11].root2 = 5;   

      array3[12].root1 = 1;
      array3[12].root2 = 5; 

      array3[13].root1 = 1;
      array3[13].root2 = 5;    


      array3[14].root1 = 1;
      array3[14].root2 = 5; 


      array3[15].root1 = 1;
      array3[15].root2 = 5; 

      array3[16].root1 = 1;
      array3[16].root2 = 4;

      array3[17].root1 = 1;
      array3[17].root2 = 3;

      array3[18].root1 = 1;
      array3[18].root2 = 3;

      var temp2 =[];
      for (var i = 0; i < 19; i++) {
          temp2.push(array3[i].val);
          if(array3[i].val > 0) {
              array2[array3[i].root2] ++;
              array1[array3[i].root1] ++;
          }
      }

      d.array1 = array1;
      d.array2 = array2;
      d.array3 = temp2;
      // d.array = [];
      // d.array.push(array1);
      // d.array.push(array2);
      // d.array.push(temp2);
    });
  console.log("sourse");
    console.log(sou);

  // end preprocess 


  nodes.forEach(function(d,i) {
    if (i == 0) {
      d.x = 0;
      d.y = 0;
      d.fx = 0;
      d.fy = 0;
      d.r = 200;
      d.clicked = 0;
      d.recommend = 0;
      d.over = 0;
      d.scaler = 1.2;
      d.shrink = 0;

      // d.cluster = 0;
    }
    else {
      
      // d.x = 0 + Math.floor(Math.random() * widthDot) - widthDot / 2;
      // d.x = getX();
      // d.x = -widthDot/2;
      // d.x = 0;
      // d.y = 0 + Math.floor(Math.random() * heightDot) - heightDot / 2;
      // d.y = getY();
      var arrayXY = get();
      d.x = arrayXY[0];
      d.y = arrayXY[1];
      // d.y = -heightDot/2;
      // d.y = 0;
      d.vx = 0;
      d.vy = 0;
      // d.r = Math.sqrt((i + 1) / m * -Math.log(Math.random())) * maxRadiusDot;
      d.r = 12;
      d.clicked = 0;
      d.recommend = 0;
      d.over = 0;
      d.scaler = 3;
      d.shrink = 0;

      d.array1 = sou[i-1].array1;
      d.array2 = sou[i-1].array2;
      d.array3 = sou[i-1].array3;
      d.array = [];
      d.array.push(d.array1);
      d.array.push(d.array2);
      d.array.push(d.array3);
      // d.array1 = sou[i].array1;

      // d.cluster = d.i;
    }
  
    if (!clusters[d.i] || (d.r > clusters[d.i].radius)) {
      clusters[d.i] = d;
    }
  });

  console.log(nodes);
  console.log(clusters);

  // console.log(rawData);
  var forceCollide = d3.forceCollide()
    .radius(function(d,i) { 
      if (i === 0) { return d.r + 10;}
      else {return d.r*1.3; }
    })
    .iterations(5);


  var stren = 0.016;
  const forceX = d3.forceX().strength(stren/2)
  const forceY = d3.forceY().strength(stren)



  var force = d3.forceSimulation()
    .velocityDecay(0.3)
    .nodes(nodes)
    // .force('center', d3.forceCenter)
    .force("collide", forceCollide)
    // .force("cluster", forceCluster)
    // .force("gravity", d3.forceManyBody(300))
    // .force("r", d3.forceRadial(300))
    .force("x", forceX)
    .force("y", forceY)
    .on("tick", tick);

// var str = nodes[80].url + " target=&quot;blank&quot;";
// console.log(str);

  var circle = svg.append("g").selectAll("circle")
    .data(nodes)
    .enter()
    // .append("a")
    // .attr("xlink:href", function(d) { return d.url + " target=&quot;blank&quot;"; })
    .append("circle")
    .attr("r", function(d,i) { return d.r; })
    // .style("fill", function(d) { return color(d.cluster); })
    .style("fill", "black")
    .style("stroke",function(d,i){
      if(i == 0) return "red";
      else return "#333";
    })

    .on("mouseover", function(d,i) {
      d.over = 1;
      if(d.clicked == 0 && d.recommend == 0) {
        var that = d3.select(this);
        var colorSave = d3.hsl(that.style("fill"));
        // console.log(colorSave);

        that        
        .transition().duration(function(d,i){
          if(i == 0) return 400;
          else return 0;
        })
        .style('fill', function(d) {
          // var colorSave = d3.hsl(that.attr("fill"));
          // console.log(colorSave);
          colorSave.s = 1;

          return colorSave;
        })
        .attr("r", function (d,i){
            d.r = d.r*d.scaler;
            return d.r;
        });
        force.nodes(nodes)
        force.alpha(0.3).restart();

      }

       div.transition()
         .duration(50)
         .style("opacity", .8);
       div.html("Author: " + d.main_speaker + "<br/>" + "Title: " + d.title)
         .style("left", (d3.event.pageX+40) + "px")
         .style("top", (d3.event.pageY - 60) + "px");
       })

     .on("mouseout", function(d) {
      d.over = 0;

      if(d.clicked == 0 && d.recommend == 0) {
        var that = d3.select(this);
        var colorSave = d3.hsl(that.style("fill"));

        that        
        .transition().duration(200)
        .style('fill', function(d) {
          // var colorSave = d3.hsl(that.attr("fill"));
          // console.log(colorSave);
          colorSave.s = 0.5;
          return colorSave;
        })
        .attr("r", function (d,i){
            d.r = d.r/d.scaler;
            return d.r;
        });
        force.nodes(nodes);
        force.alpha(0.3).restart();

      }

       div.transition()
         .duration(100)
         .style("opacity", 0);

       })

     .on("click",function(d,i) {

      if (i != 0) {
        d3.select(this)
          .style("fill","red");
        d.clicked = 1;

        openInNewTab(d.url);


//start  radius
      var newRadius = 0;
      d3.select(this)
      .transition().duration(200)
        .tween('radius', function(d) {
          var that = d3.select(this);
          var i = d3.interpolate(d.r, newRadius);
          return function(t) {
            d.r = i(t);
            that.attr('r', function(d) { return d.r; });
            force.nodes(nodes)
          }
        });
     force.alpha(0.3).restart();

//end
      }

      else if (i == 0) {
        random(5);
      }




     });

     var shift = 20;
     var textTED = svg.append("text")
       .attr("text-anchor","middle")
       .attr("id","text1")
       .attr("x",30)
       .attr("y",0-height + shift)
       .text("TED")
       .style("font-family","Helvetica Neue")
       .style("font-size","65px");

      var text1 = svg.append("text")
       .attr("text-anchor","middle")
       .attr("id","text1")
       .attr("x",0)
       .attr("y",0-height + shift)
       .text("There are over 1000 \u00A0 \u00A0 \u00A0 \u00A0 \u00A0talks in the world.")
       .style("font-family","Helvetica Neue")
       .style("font-size","60px");

       text1
      .transition()
      .duration(2500)
      .style("fill","white");

      textTED
      .transition()
      .duration(2500)
      .style("fill","white");

      textTED
      .transition()
      .duration(1500)
      .delay(2000)
      .style("fill","red");



  function tick() {


      circle
      .attr("cx", function(d) { return d.x; })
      .attr("cy", function(d) { return d.y; })
      .attr("r", function(d,i) { 
        var thisnode = nodes[i];
        if(i == 0) {
          // console.log(thisnode);
        }
        // console.log(thisnode);
        var temp = Math.sqrt(d.x*d.x + d.y*d.y)/40;
        if(temp > maxRadiusDot && thisnode.clicked == 0 &&thisnode.index != 0 && thisnode.over == 0 && thisnode.recommend == 0 && thisnode.shrink == 0) {
          thisnode.r = maxRadiusDot;
          return maxRadiusDot;

        }
        else if (temp < minRadiusDot && thisnode.clicked == 0 && thisnode.index != 0 && thisnode.over == 0 && thisnode.recommend == 0 && thisnode.shrink == 0) {
          thisnode.r = minRadiusDot;
          return minRadiusDot;
        }
        else if (thisnode.index != 0 && thisnode.clicked == 0 && thisnode.over == 0 && thisnode.recommend == 0 && thisnode.shrink == 0) 
        {
          thisnode.r = temp;
          return temp;
        }
        else {
          return thisnode.r;
          } 
      })
      .style("fill",function(d,i) {
        var thisnode = nodes[i];
        if(thisnode.over == 0 && thisnode.recommend == 0 && i!=0 && thisnode.shrink == 0) {
          var temp = Math.sqrt(d.x*d.x + d.y*d.y)/35;
          // thisnode.h = 360;
          // thisnode.s = 0.5;
          // thisnode.l = 1;

        // console.log(temp);
          return d3.hsl(360,1-temp/25,0.5,0.8);
        }
        else return d3.select(this).style("fill");
        
      });
  force.nodes(nodes);

  }

  function randomSingle(length,times,now) {
  var lucky = Math.floor(Math.random() * length);
  var that = d3.selectAll("circle")
  .filter(function(d,i) { return i === lucky; });
  var colorSave = d3.hsl(that.style("fill"));
  var brighter = colorSave;
  brighter.s = 1;
  var delay = 500;


  that
  .transition()
  .duration(delay)
  .delay(delay*now*2)
  .style("fill","red")
  .attr("r", function (d,i){
            d.recommend = 1;
            d.r = d.r*d.scaler;
            return d.r;
        });
  force.nodes(nodes)
  force.alpha(0.3).restart();



  //   that
  //     .transition()
  //     .duration(delay)
  //     .delay(delay*now*3)
  //     .style("fill",colorSave)
  //     .attr("r", function (d,i){
  //           d.recommend = 0;
  //           d.r = d.r/d.scaler;
  //           return d.r;
  //       });
  // force.nodes(nodes)
  // force.alpha(0.3).restart();


  
}


function random(times) {
  var length = nodes.length;
        
  for(var i = 0; i < times; i ++) {
    randomSingle(length,times,i);
    
  }
}


  //sunbrust
  var currentDepth = 0; //1 zoom in 0 zoom out 
  root = d3.hierarchy(root);
  // console.log(root);
  root.sum(d => d.size);

  const slice = svg.selectAll('g.slice')
      .data(partition(root).descendants());

  slice.exit().remove();

  const newSlice = slice.enter()
      .append('g').attr('class', 'slice')
      .on('click', d => {

        var direction = d.depth > currentDepth ? 1 : 0;
        currentDepth = d.depth;
        console.log(currentDepth);
        // console.log(direction);
        var sliceData = d;

        console.log(d);
          d3.event.stopPropagation();
          focusOn(d);
          //nextstep

          if(currentDepth != 0) {
            d3.selectAll("circle")
            .filter(function(d,i){
              if(i == 0) return 0;
              var thisNode = nodes[i];
              var depthIndex = sliceData.depth-1;
              var Index = sliceData.data.index;
              if(thisNode.array[depthIndex][Index] >0)
              { 
                console.log("win");
                if(direction == 1) {return 0;}
                else if (direction == 0) {
                  d.shrink = 0;
                  return 1;
                }
              }
              else {
                if(direction == 1) {return 1;}
                else if (direction == 0) {return 0;}
              }
              // console.log(depthIndex)
              // console.log(Index)
            })
            .attr("r",function(d){
              if(direction == 1) {d.shrink = 1;}
                d.r = 0;
                return d.r;
              
            });
            force.alpha(0.5).restart();
          }

          else {
              d3.selectAll("circle")
                .filter(function(d,i){
                  console.log("win");
                  d.shrink = 0;
                  return 0;
                })
          }

      });

  newSlice.append('title')
      .text(d => d.data.name + '\n' + formatNumber(d.value));

  newSlice.append('path')
      .attr('class', 'main-arc')
      // .style('fill', d => color((d.children ? d : d.parent).data.name))
      .style('fill', d => color(d.depth))
      .attr('d', arc);

  newSlice.append('path')
      .attr('class', 'hidden-arc')
      .attr('id', (_, i) => `hiddenArc${i}`)
      .attr('d', middleArcLine);

  const text = newSlice.append('text')
                        .style("fill", "#ccc");
      // .attr('display', d => textFits(d) ? null : 'none');

  // Add white contour
  // text.append('textPath')
  //     .attr('startOffset','50%')
  //     .attr('xlink:href', (_, i) => `#hiddenArc${i}` )
  //     .text(d => d.data.name)
  //     .style('fill', 'none')
      // .style('stroke', '#fff')
      // .style('stroke-width', 5)
      // .style('stroke-linejoin', 'round');

  text.append('textPath')
      .attr('startOffset','50%')
      .attr('xlink:href', (_, i) => `#hiddenArc${i}` )
      .text(d => d.data.name);

      function focusOn(d = { x0: 0, x1: 1, y0: 0, y1: 1 }) {
    // Reset to top-level if no data point specified

      const transition = svg.transition()
          .duration(750)
          .tween('scale', () => {
              const xd = d3.interpolate(xScaler.domain(), [d.x0, d.x1]),
                  yd = d3.interpolate(yScaler.domain(), [d.y0, 1]);
              return t => { xScaler.domain(xd(t)); yScaler.domain(yd(t)); };
          });

      transition.selectAll('path.main-arc')
          .attrTween('d', d => () => arc(d));

      transition.selectAll('path.hidden-arc')
          .attrTween('d', d => () => middleArcLine(d));

      transition.selectAll('text')
          .attrTween('display', d => () => textFits(d) ? null : 'none');

      moveStackToFront(d);

      //

      function moveStackToFront(elD) {
          svg.selectAll('.slice').filter(d => d === elD)
              .each(function(d) {
                  this.parentNode.appendChild(this);
                  if (d.parent) { moveStackToFront(d.parent); }
              })
      }
    }


};




</script>
