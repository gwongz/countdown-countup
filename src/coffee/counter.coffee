React = require 'react'
$ = require 'jquery'


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
  
  toggleTimer: (e) ->
    console.log 'timer button was clicked'
    e.preventDefault()
    # call callback on parent
    this.props.onButtonClick(timerOn: !this.state.timing)
    this.setState(timing: !this.state.timing)

  render: ->
    if this.state.timing
      <input type="submit" value="Stop" onClick={this.toggleTimer} />

    else
      <input type="submit" value="Resume" onClick={this.toggleTimer} />


Timer = React.createClass
  mixins: [SetIntervalMixin]

  getInitialState: ->
    this.calculateTime(this.props.data.occurs)


  calculateTime: (futureTime) ->
    # set the state to the right values
    now = new Date().getTime()
    diff = Math.abs(futureTime - now) 

    secondsPerDay = 60 * 60 * 24
    secondsPerYear = secondsPerDay * 365
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
    countdown = this.props.countdown
    msg = if countdown then 'happens in' else 'happened'
    ago = if !countdown then 'ago' else ''

    years = parseInt(this.state.days / 365)
    days = if years then (this.state.days % 365) else this.state.days

    <div className="timer">
      <h1>{this.props.data.title} {msg}</h1>

      <span>{years} years </span>
      <span>{days} days </span>
      <span>{this.state.hours} hours </span>
      <span>{this.state.minutes} minutes </span>
      <span>{this.state.seconds}.{this.state.milliseconds} seconds </span>
      {ago}
      <div>
        <TimerButton onButtonClick={this.toggleTimer} />
      </div>
    </div>

CountForm = React.createClass
  handleSubmit: (e) ->
    console.log 'submitting form'
    e.preventDefault()
    this.resetError()
    title = this.refs.title.getDOMNode().value.trim()
    occurs = this.refs.occurs.getDOMNode().value.trim()
    date = Date.parse(occurs)

    # valid date was not submitted
    if isNaN(date)
      console.log 'this is not a number'
      $('.countError').text('Please enter a valid date')
      return

    console.log 'this is a valid date'
    this.props.onFormSubmit({title: title, occurs: date})
    this.refs.title.getDOMNode().value = '';
    this.refs.occurs.getDOMNode().value = '';

  resetError: ->
    $('.countError').text('')

  render: ->
    question = if this.props.countdown then 'What are you counting down to?' else 'What are you counting up from?' 
    currentYear = new Date().getFullYear()
    pi = "3/15/#{currentYear}"
    if Date.parse(pi) < new Date()
      pi = "3/15/#{currentYear + 1}"

    <form className="countForm" onSubmit={this.handleSubmit}>
      <h1>{question}</h1>
      <input type="text" name="title" ref="title" onClick={this.resetError} />
      <label for="title">Name of event</label> 
 
      <input type="text" ref="occurs" name="occurs" onClick={this.resetError} />
      <label for="occurs">{this.props.msg}</label>

      <div className="countError"></div>
      <div className="submitDiv">
        <input type="submit" value="Start counting"/>
      </div>
    </form>



CountBox = React.createClass
  getInitialState: ->
    counting: false
    countdown: this.props.countdown
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
    this.setState
      counting: true
      data: data
      countdown: this.state.countdown
    


  render: ->
    if this.state.counting
      <Timer countdown={this.state.countdown} data={this.state.data} />

    else  
      msg = if this.state.countdown then 'Happens on' else 'Happened'
      <CountForm countdown={this.state.countdown} msg={msg} onFormSubmit={this.handleFormSubmit}/>


AppLayer = React.createClass 
  getInitialState: ->
    countdown: true
    count: 1

  toggleView: ->
    this.setState
      countdown: !this.state.countdown
      count: this.state.count + 1
    

  render: -> 
    action = if this.state.countdown then 'Count up' else 'Count down'
    <div className="appLayer" key={this.state.count}>
      <p onClick={this.toggleView}>
      {action} instead</p>
      <div className="countBox">
        <CountBox countdown={this.state.countdown} />
      </div>
    </div>

React.render(
  <AppLayer/>,
  document.getElementById('content')
);

