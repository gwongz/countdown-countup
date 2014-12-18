
var converter = new Showdown.converter();
var Comment = React.createClass({
  render: function(){
    return (
      <div className="content">
        <h2 className="contentAuthor">
          {this.props.author}
        </h2>
        <h3>{this.props.text}</h3>

      </div>
    );
  }
});

# CommentBox component
var CommentBox = React.createClass({
  # like initialize in BackboneView
  getInitialState: function() {
    console.log('getting comment box initial state');
    return {data: []};
  },

  loadCommentsFromServer: function() {
    console.log('in load comments from server');
    var self = this;
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(data) {
        console.log(data);
        self.setState({data: data});
      }.bind(self),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });

  },

  handleCommentSubmit: function(comment) {
    // optimistically update list before waiting for request to complete
    var comments = this.state.data;
    var newComments = comments.concat([comment]);
    this.setState({data: newComments});


    //submit to the server and refresh the list
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      contentType: 'application/json',
      type: 'POST',
      data: JSON.stringify(comment),
      success: function(data) {
        this.setState({data: data});
      }.bind(this),
      error: function(data) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  // load when component is rendered and then fetch every 2000
  // use setInterval if you need streaming data 
  componentDidMount: function() {
    this.loadCommentsFromServer();
    // setInterval(this.loadCommentsFromServer, this.props.pollInterval);

  },
  // a tree of React components that will render to html
  render: function() {
    return (
      // instantiate React div components, markers for React
      // accessible via this.props.data 
      // this.props.onCommentSubmit
      <div className="commentBox">
        <h1>Comments</h1>
        <CommentList data={this.state.data}/> 
        <CommentForm onCommentSubmit={this.handleCommentSubmit} /> 
      </div>
    );
  }
});

// CommentList component
var CommentList = React.createClass({
  // data passed from parent to children components is called props
  render: function() {
    var commentNodes = this.props.data.map(function(comment) {
      return (
        <Comment author={comment.author} text={comment.text}>
        </Comment>
      );
    });
    return (
      <div className="commentList">
        {commentNodes}
      </div>
    );
  }
});

var CommentForm = React.createClass({
  handleSubmit: function(e) {
    e.preventDefault();
    var author = this.refs.author.getDOMNode().value.trim();
    var text = this.refs.text.getDOMNode().value.trim();
    if (!text || !author) {
      return;
    }

    // call the callback on submit so CommentBox will refresh
    this.props.onCommentSubmit({author: author, text: text});
    // TODO: send request to the server
    this.refs.author.getDOMNode().value = '';
    this.refs.text.getDOMNode().value = ''

  },
  render: function() {
    return (
      <form className="commentForm" onSubmit={this.handleSubmit}>
        <input type="text" placeholder="Your name" ref="author"/>
        <input type="text" placeholder="Say something..." ref="text"/>
        <input type="submit" value="Post" />
      </form>
 
    );
  }
});

var Counter = React.createClass({
  getInitialState: function() {
    return {count: 0}
  },

  addCount: function(delta){
    var newCount = this.state.count + delta;
    this.setState({count: newCount});
  },

  render: function() {
    return (
      <div>
      <button className="counterButton">
      Counts: {this.state.count}
      </button>

      <button className="incrementCount" onClick={this.addCount.bind(this, 1)}>
      +1
      </button>

  

      <button className="decrementCount" onClick={this.addCount.bind(this, -1)}>
      -1 
      </button>

      </div>
    );

  },
})

var Clock = React.createClass({
  getInitialState: function(){
    return {timeOfDay: this.props.timeOfDay}

  },

  loadTime: function() {
    this.setState({timeOfDay: new Date()});

  },

  componentDidMount: function(){
    // happens when render is called
    this.loadTime();
    setInterval(this.loadTime, this.props.clockInterval);


  },


  render: function() {
    return (
      <div className="timeOfDay">
      {this.state.timeOfDay.toString()}
      </div>
    );

  },

});


React.render(
  <CommentBox url="/comments" pollInterval={2000} />,  // instantiate root component
  document.getElementById('content')  // inject markup into a raw DOM element 'content'
);

React.render(
  <Counter />, 
  document.getElementById('counter')
);

React.render(
  <Clock timeOfDay={new Date()} clockInterval={1000} />,
  document.getElementById('clock')
);