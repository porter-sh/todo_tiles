var should = require('should');
var span = require('../index');

describe('Span', function() {
  describe('interface', function() {
    it('should export a function', function() {
      span.should.be.an.instanceOf(Function);
    });
    it('should parse itself', function() {
      span(span('3d 2h')).should.equal('3d 2h');
      span(span(266400000)).should.equal(266400000);
    })
  });

  describe('str to ms', function() {
    it('should ignore whitespace', function() {
      span('1 day').should.equal(span('1day'));
    });
    it('should speak english', function() {
      span('1 second').should.equal(1000);
      span('1 minute').should.equal(60000);
      span('1 hour').should.equal(3600000);
      span('1 day').should.equal(86400000);
      span('1 week').should.equal(604800000);
    });
    it('should speak german', function() {
      span('1 sekunde').should.equal(1000);
      span('1 minute').should.equal(60000);
      span('1 stunde').should.equal(3600000);
      span('1 tag').should.equal(86400000);
      span('1 woche').should.equal(604800000);
    });
    it('should understand short forms', function() {
      span('2 seconds').should.equal(2000);
      span('1 second').should.equal(1000);
      span('2 secs').should.equal(2000);
      span('1 sec').should.equal(1000);
      span('1 sec').should.equal(1000);
    });
    it('should recognize numbers as strings', function() {
      span('1000').should.equal('1s');
    });
    it('should understand composited values', function() {
      span('3d 2h').should.equal(266400000);
      span('3d 2m').should.equal(259320000);
    });
  });

  describe('ms to str', function() {
    it('should output milliseconds', function() {
      span(100).should.equal('100ms');
    });
    it('shouldn\'t output milliseconds if >=1s', function() {
      span(1000).should.equal('1s');
      span(1001).should.equal('1s');
    });
    it('should output composited values', function() {
      span(266400000).should.equal('3d 2h');
      span(259320000).should.equal('3d 2m');
    });
    it('should support big values', function() {
      span(1000).should.equal('1s')
      span(60000).should.equal('1m')
      span(3600000).should.equal('1h')
      span(86400000).should.equal('1d')
      span(604800000).should.equal('1w')
      span(31557600000).should.equal('1y')
    })
  });
});
