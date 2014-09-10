# @cjsx React.DOM

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

@PeopleSection = React.createClass
  displayName: 'PeopleSection'

  getInitialState: ->
    didFetchData: false
    people: []
    meta:
      total_pages: 0
    fetchData:
      search: ''
      onPaginate: 1

  componentDidMount: ->
    @_fetchPeople({})

  _fetchPeople: ()->
    $.ajax
      url: Routes.people_path()
      dataType: 'json'
      data: @state.fetchData
    .done @_fetchDataDone
    .fail @_fetchDataFail

  _fetchDataDone: (data, textStatus, jqXHR) ->
    return false unless @isMounted()
    @setState
      didFetchData: true
      people: data.people
      meta: data.meta

  _fetchDataFail: (xhr, status, err) =>
    console.error @props.url, status, err.toString()

  _handleOnSearchSubmit: (search) ->
    @state.fetchData=
      search: search
      page: 1

    @_fetchPeople()

  _handleOnPaginate: (pageNumber) ->
    @state.fetchData.page = pageNumber
    @_fetchPeople()

  render: ->
    cardsNode = @state.people.map (person) ->
      <PersonCard key={person.id} data={person}/>

    noDataNode =
      <div className="warning">
        <span className="fa-stack">
          <i className="fa fa-meh-o fa-stack-2x"></i>
        </span>
        <h4>No people found...</h4>
      </div>

    <div>
      <PeopleSearch onFormSubmit={@_handleOnSearchSubmit}/>
      <PaginatorSection meta={@state.meta} onPaginate={@_handleOnPaginate}/>
      <div className="cards-wrapper">
        {
          if @state.people.length > 0
            <ReactCSSTransitionGroup transitionName="card">
              {cardsNode}
            </ReactCSSTransitionGroup>
          else if @state.didFetchData
            {noDataNode}
        }
      </div>
    </div>
