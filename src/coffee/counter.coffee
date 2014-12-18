React = require 'react'
moment = require('moment');

SetIntervalMixin = 
  componentWillMount: -> 
    this.intervals = [];
  
  setInterval: -> 
    this.intervals.push(setInterval.apply(null, arguments));
  
  componentWillUnmount: ->
    this.intervals.map(clearInterval);


TimerButton = React.createClass
  getInitialState: ->
    timing: true
  
  toggleTimer: ->
    console.log 'timer button was clicked'
   
    # call callback on parent
    this.props.onButtonClick(timerOn: !this.state.timing)
    this.setState(timing: !this.state.timing)

  render: ->
    if this.state.timing
      <button className="toggleTimer" onClick={this.toggleTimer}>
        Stop 
      </button>
    else
      <button className="toggleTimer" onClick={this.toggleTimer}>
        Resume
      </button>


Timer = React.createClass
  mixins: [SetIntervalMixin]

  getInitialState: ->
    this.calculateTime(this.props.data.occurs)


  calculateTime: (futureTime) ->
    # set the state to the right values
    now = new Date().getTime()
    diff = Math.abs(futureTime - now) 

    secondsPerDay = 60 * 60 * 24
    seconds = diff / 1000

    # extract days 
    days = parseInt(seconds / secondsPerDay)
    # seconds remaining after extracting days 
    seconds = seconds % secondsPerDay


    # extract hours 
    hours = parseInt( seconds / 3600)
    # seconds remaining after extracting hours
    seconds = seconds % 3600 

    minutes = parseInt(seconds / 60)
    # seconds after extracting minutes
    seconds = seconds % 60 

    milliseconds = seconds * 1000
    seconds = parseInt(milliseconds / 1000)
    milliseconds = parseInt(milliseconds % 1000)

    days: days
    hours: hours 
    minutes: minutes 
    seconds: seconds 
    milliseconds: milliseconds






  tick: ->
    newValues = this.calculateTime(this.props.data.occurs)
    this.setState(
      seconds: newValues.seconds,
      minutes: newValues.minutes,
      hours: newValues.hours,
      days: newValues.days,
      milliseconds: newValues.milliseconds
    )

  componentDidMount: ->
    this.setInterval(this.tick, 100)

  toggleTimer: (data) ->
    console.log('this is value of data timeron in the callback')
    console.log(data.timerOn)

    if data.timerOn
      this.componentDidMount()
    else
      # clearInterval
      console.log 'want to stop the timer was clicked'
      this.intervals.map(clearInterval)
    

  render: ->
    <div className="timer">
      <h1>Count down to {this.props.data.title}</h1>
      <span>{this.state.days} days </span>
      <span>{this.state.hours} hours </span>
      <span>{this.state.minutes} minutes </span>
      <span>{this.state.seconds}.{this.state.milliseconds} seconds </span>
      <div className="timerButton">
        <TimerButton onButtonClick={this.toggleTimer} />
      </div>
    </div>

CountdownForm = React.createClass
  handleSubmit: (e) ->
    console.log 'submitting countdown form'
    e.preventDefault()
    title = this.refs.title.getDOMNode().value.trim()
    occurs = this.refs.occurs.getDOMNode().value.trim()
    date = Date.parse(occurs)

    if date > new Date()
      console.log 'this is a valid date'
      this.props.onFormSubmit({title: title, occurs: date})

    else 
      this.refs.title.getDOMNode().value = '';
      this.refs.occurs.getDOMNode().value = '';


  render: ->
    <form className="countForm" onSubmit={this.handleSubmit}>
      
      <input type="text" ref="title" /> 
      <span> starts on </span>
      <input type="text" ref="occurs" />
      <div className="submitDiv">
        <input type="submit" value="Begin count down"/>
      </div>
    </form>

CountupForm = React.createClass
  handleSubmit: (e) ->
    console.log 'submitting countup form'
    e.preventDefault()

  render: ->
    <form className="countForm" onSubmit={this.handleSubmit}>
      <h1>What are you counting up from?</h1>
      <input type="text" ref="title" />
      <h1>When do you want to count up from?</h1>
      <input type="text" ref="occurs" />
      <div className="submitDiv">
        <input type="submit" value="Begin counting" />
      </div>
    </form>

CountForm = React.createClass
  getInitialState: ->
    counting: Boolean(this.props.counting)
    countdown: Boolean(this.props.countdown)
    data: []

  handleFormSubmit: (data) ->
    console.log 'in the form submit callback'
    console.log('this is data.title')
    console.log(data.title)
    console.log 'and data.date'
    console.log data.occurs
    console.log 'the value of counting state'
    console.log typeof(this.state.counting)
    # reset counting state 
    this.setState(
      counting: true
      data: data
      countdown: this.state.countdown
    )


  render: ->
    if this.state.counting
      console.log 'counting is true and so is countdown so render countdown timer'
      <Timer countdown={this.state.countdown.toString()} data={this.state.data} />

    else if not this.state.counting and this.state.countdown 
      console.log 'we want to show the form and not the timer for countdown'
      <CountdownForm countdown="true" onFormSubmit={this.handleFormSubmit}/>

    else 
      console.log 'we want to show the count up form and not the timer '
      <CountupForm countdown="false" onFormSubmit={this.handleFormSubmit}/>



CountBox = React.createClass
  render: ->
    console.log 'the value of counting in countbox rendering'
    console.log this.props.counting
    <div className="countBox">
      <CountForm countdown={this.props.countdown} counting={this.props.counting}/> 
    </div>


AppLayer = React.createClass 
  getInitialState: ->
    countdown: Boolean(this.props.countdown)
    counting: false;

  toggleView: ->
    countdown = this.state.countdown
    this.setState(
      countdown: !countdown
      counting: false
    )

  render: -> 
    <div className="appLayer">
      <p onClick={this.toggleView}>This is value of countdown {this.state.countdown.toString()}</p>
      <CountBox countdown={this.state.countdown} counting={this.state.counting}/>
    </div>

React.render(
  <AppLayer countdown="true" counting="false"/>,
  document.getElementById('content')
);

