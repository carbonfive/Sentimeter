const d3 = require('d3');
const Tabletop = require('tabletop');
const _ = {
  map: require('lodash/map'),
  uniqBy: require('lodash/uniqBy'),
  capitalize: require('lodash/capitalize'),
  each: require('lodash/each')
};

const Radar = require('./models/radar');
const Quadrant = require('./models/quadrant');
const Ring = require('./models/ring');
const Blip = require('./models/blip');
const RadarPlotter = require('./graphing/radar');
const MalformedDataError = require('./exceptions/malformedDataError');
const ExceptionMessages = require('./util/exceptionMessages');

const plotRadar = function (selector, title, blips) {
  document.title = title;
  d3.selectAll(".loading").remove();

  var rings = _.map(_.uniqBy(blips, 'ring'), 'ring');
  var ringMap = {};
  var maxRings = 4;

  _.each(rings, function (ringName, i) {
    if (i == maxRings) {
      throw new MalformedDataError(ExceptionMessages.TOO_MANY_RINGS);
    }
    ringMap[ringName] = new Ring(ringName, i);
  });

  var quadrants = {};
  _.each(blips, function (blip) {
    if (!quadrants[blip.quadrant]) {
      quadrants[blip.quadrant] = new Quadrant(_.capitalize(blip.quadrant));
    }
    quadrants[blip.quadrant].add(new Blip(blip.name, ringMap[blip.ring], blip.isNew.toLowerCase() === 'true', blip.topic, blip.description))
  });

  var radar = new Radar();
  _.each(quadrants, function (quadrant) {
    radar.addQuadrant(quadrant)
  });

  var size = (window.innerHeight - 133) < 620 ? 620 : window.innerHeight - 133;

  new RadarPlotter(selector, size, radar).init().plot();
}

const ApiRadar = function (selector, reportGuid) {
  var self = {};

  self.build = function () {
    createBlips();
  }

  var createBlips = async (data) => {
    try {
      const response = await fetch(`/api/reports/${reportGuid}`, {
        headers: {
          'content-type': 'application/json'
        }
      })

      data = await response.json();
      const report = data['data'];
      const ringNames = {
        1: report.innermost_level_name,
        2: report.level_2_name,
        3: report.level_3_name,
        4: report.outermost_level_name
      };
      const quadrantNames = {
        1: report.category_1_name,
        2: report.category_2_name,
        3: report.category_3_name,
        4: report.category_4_name
      };

      const blips = _.map(report.report_trends, (reportTrend) => {
        const reportTrendAverage = report.report_trend_averages.find((reportTrendAverage) =>
          reportTrendAverage.radar_trend_guid === reportTrend.radar_trend_guid
        )
        return {
          name: reportTrend.name,
          quadrant: quadrantNames[reportTrend.category],
          isNew: "true",
          topic: null,
          description: reportTrend.description,
          ring: ringNames[Math.round(reportTrendAverage.average)]
        };
      });
      plotRadar(selector, report.name, blips);
    } catch (exception) {
      plotErrorMessage(selector, exception);
    }
  }

  self.init = function () {
    plotLoading(selector);
    return self;
  };

  return self;
};

const GraphingRadar = function () {
  var self = {};

  self.build = function (selector, reportGuid) {
    ApiRadar(selector, reportGuid).init().build();
  };

  return self;
};

function set_document_title() {
  document.title = "Build your own Radar";
}

function plotLoading(selector) {
  var content = d3.select(selector)
    .append('div')
    .attr('class', 'loading')
    .append('div')
    .attr('class', 'input-sheet');

  set_document_title();

  plotLogo(content);

  var bannerText = '<h1>Building your radar...</h1><p>Your Technology Radar will be available in just a few seconds</p>';
  plotBanner(content, bannerText);
  plotFooter(content);
}

function plotLogo(content) {
  content.append('div')
    .attr('class', 'input-sheet__logo')
    .html('<a href="https://www.carbonfive.com"><img src="/images/C5_final_logo_horiz.png" / ></a>');
}

function plotFooter(content) {
  content
    .append('div')
    .attr('id', 'footer')
    .append('div')
    .attr('class', 'footer-content')
    .append('p')
    .html('Powered by <a href="https://www.thoughtworks.com"> ThoughtWorks</a>. ' +
      'By using this service you agree to <a href="https://www.thoughtworks.com/radar/tos">ThoughtWorks\' terms of use</a>. ' +
      'You also agree to our <a href="https://www.thoughtworks.com/privacy-policy">privacy policy</a>, which describes how we will gather, use and protect any personal data contained in your public Google Sheet. ' +
      'This software is <a href="https://github.com/thoughtworks/build-your-own-radar">open source</a> and available for download and self-hosting.');



}

function plotBanner(content, text) {
  content.append('div')
    .attr('class', 'input-sheet__banner')
    .html(text);

}

function plotErrorMessage(selector, exception) {
  d3.selectAll(".loading").remove();
  var message = 'Oops! It seems like there are some problems with loading your data. ';

  if (exception instanceof MalformedDataError) {
    message = message.concat(exception.message);
  } else if (exception instanceof SheetNotFoundError) {
    message = exception.message;
  } else {
    console.error(exception);
  }

  message = message.concat('<br/>', 'Please check <a href="https://www.thoughtworks.com/radar/how-to-byor">FAQs</a> for possible solutions.');

  d3.select(selector)
    .append('div')
    .attr('class', 'error-container')
    .append('div')
    .attr('class', 'error-container__message')
    .append('p')
    .html(message);
}

module.exports = GraphingRadar;