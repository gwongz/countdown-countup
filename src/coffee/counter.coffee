React = require 'react'

CountdownForm = React.createClass

  handleSubmit: (e) ->
    console.log 'submitting countdown form'
    e.preventDefault()

  render: ->
    <form className="countForm" onSubmit={this.handleSubmit}>
      <h1>What are you counting down to?</h1>
      <input type="text" ref="title" />
      <h1>When does it start?</h1>
      <input type="text" ref="occurs" />
      <input type="submit" value="Begin count down"/>
    </form>

CountupForm = React.createClass
  handleSubmit: (e) ->
    console.log 'submitting countup form'
    e.preventDefault()

  render: ->
    <form className="countForm" onSubmit={this.handleSubmit}>
      <h1>What are you counting up from?</h1>
      <input type="text" ref="title" />
      <h1>When did it happen?</h1>
      <input type="text" ref="occurs" />
      <input type="submit" value="Begin counting" />
    </form>

CountForm = React.createClass
  render: ->
    console.log 'rendering countform'
    if (this.props.countdown) 
      console.log 'countdown is ture'
      countForm = <CountdownForm />
    else
      console.log 'countdown is false'
      countForm = <CountupForm />
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

