React = require 'react'

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
      <h1>What are you counting down to?</h1>
      <input type="text" ref="title" />
      <h1>When does it start?</h1>
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
  handleFormSubmit: (data) ->
    console.log 'in the form submit callback'
    console.log('this is data.title')
    console.log(data.title)
    console.log 'and data.date'
    console.log data.occurs
  
  render: ->
    console.log 'rendering countform'
    if (this.props.countdown) 
      console.log 'countdown is ture'
      countForm = <CountdownForm onFormSubmit={this.handleFormSubmit}/>
    else
      console.log 'countdown is false'
      countForm = <CountupForm onFormSubmit={this.handleFormSubmit}/>
    countForm

CountBox = React.createClass
 


  render: ->
    <div className="countBox">
      <CountForm countdown={this.props.countdown} /> 
    </div>


AppLayer = React.createClass 
  getInitialState: ->
    initialcountdown = this.props.countdown
    {countdown: Boolean(this.props.countdown)}

  toggleView: ->
    countdown = this.state.countdown
    this.setState({countdown: !countdown})

  render: -> 
    <div className="appLayer">
      <p onClick={this.toggleView}>This is value of countdown {this.state.countdown.toString()}</p>
      <CountBox countdown={this.state.countdown}/>
    </div>

React.render(
  <AppLayer countdown="true"/>,
  document.getElementById('content')
);

