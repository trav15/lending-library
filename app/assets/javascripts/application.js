// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require activestorage
//= require_tree .

$(() => {
  bindClickHandlers();
})

const bindClickHandlers = () => {
  //item index
  $('.all-items').on('click', (e) => {
    e.preventDefault();
    fetch('/items.json')
      .then(res => res.json())
      .then(items => {
        $('.app-container').html('')
        items.forEach((item) => {
          let newItem = new Item(item)
          let itemHtml = newItem.formatIndex()
          $('.app-container').append(itemHtml)
        })
      })
  })
  //show item
  $(document).on('click', '.show-link', function(e) {
    e.preventDefault();
    let id = $(this).attr('data-id')
    fetch(`/items/${id}.json`)
      .then(res => res.json())
      .then(item => {
      $('.app-container').html('')
      let newItem = new Item(item)
      let itemHtml = newItem.formatShow()
      $('.app-container').append(itemHtml)
    })
  })
  //next item
  $(document).on('click', '.next-item', function(e) {
    e.preventDefault();
    let id = $(this).attr('data-id');
    fetch(`/items/${id}/next`)
      .then(res => res.json())
      .then(item => {
      $('.app-container').html('')
      let newItem = new Item(item)
      let itemHtml = newItem.formatShow()
      $('.app-container').append(itemHtml)
    })
  })
}

function Item(item) {
  this.id = item.id
  this.name = item.name
  this.available = item.available
  this.created_at = item.created_at
  this.loan_count = item.loans.length
}

Item.prototype.formatIndex = function() {
  let itemHtml = `
    <a href="/items/${this.id}" data-id="${this.id}" class="show-link list-group-item list-group-item-action">${this.name}</h1>
  `
  return itemHtml
}

Item.prototype.formatShow = function() {
  let itemAvailablity = ''
  if (this.available == true) {
    itemAvailablity = '<span class="badge badge-success">Available To Borrow</span>'
  }
  else {
    itemAvailablity = '<span class="badge badge-danger">Borrowed</span>'
  }
  let itemHtml = `
    <h3>${this.name}</h3>
    ${itemAvailablity}<br>
    <p>Times borrowed: ${this.loan_count}</p><br>
    <button data-id="${this.id}" class="next-item badge badge-secondary">Next Item</button>
  `
  return itemHtml
}
