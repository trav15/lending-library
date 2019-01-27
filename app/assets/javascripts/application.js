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
      let newItem = new Item(item, item.loans)
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
      .then(data => {
      $('.app-container').html('')
      let newItem = new Item(data['item'], data['loans'])
      let itemHtml = newItem.formatShow()
      $('.app-container').append(itemHtml)
    })
  })

  //show item loans
  $(document).on('click', '.loan-history', function(e) {
    e.preventDefault();
    let id = $(this).attr('data-id')
    fetch(`/items/${id}.json`)
    .then(res => res.json())
    .then(item => {
      $('.button-container').html('')
      let thisItem = new Item(item, item.loans)
      item.loans.forEach((loan) => {
        let loanUser = item.users.find( user => user.id === loan.user_id)
        let newLoan = new Loan(loan, loanUser)
        let loanHtml = newLoan.formatLoans()
        $('.button-container').append(loanHtml)
      })
      let buttonHtml = thisItem.buttonFooter()
      $('.button-container').append(buttonHtml)
    })
  })

  //hide item loans
  $(document).on('click', '.hide-loan-history', function(e) {
    e.preventDefault();
    let id = $(this).attr('data-id')
    fetch(`/items/${id}.json`)
      .then(res => res.json())
      .then(item => {
      $('.button-container').html('')
      let thisItem = new Item(item, item.loans)
      let buttonHtml = thisItem.buttonFooterShow()
      $('.button-container').append(buttonHtml)
    })
  })

  //submit donation form
  $('form').submit( function(event) {
    event.preventDefault();
    let values = $(this).serialize()
    let donation = $.post('/items', values)
    donation.done(function(data) {
      alert("DONE")
      var item = data;
      let newItem = new Item(item)
      let itemHtml = newItem.formatIndex()
      $('.app-container').append('<h3>Thank you for your donation!</h3>')
      $('.app-container').append(itemHtml)
      });
   })
}

function Item(item, loans) {
  this.id = item.id
  this.name = item.name
  this.available = item.available
  this.created_at = item.created_at
  this.loans = loans
}

class Loan{
  constructor(loan, user) {
    this.used_for = loan.used_for
    this.loan_date = loan.loan_date
    this.user = user
  }
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
    itemAvailablity = `
    <span class="badge badge-success">Available To Borrow</span><br>
    <div class="form-container"><button data-id="${this.id}" class="borrow-item badge badge-secondary">Borrow Item</button></div>
  `
  }
  else {
    itemAvailablity = '<span class="badge badge-danger">Borrowed</span>'
  }
  let itemHtml = `
    <h3>${this.name}</h3>
    ${itemAvailablity}<br>
    <p>Times borrowed: ${this.loans.length}</p>
    <div class="button-container">
    <button data-id="${this.id}" class="loan-history badge badge-secondary">Show Loan History</button><br>
    <button data-id="${this.id}" class="next-item badge badge-secondary">Next Item</button>
    </div>
  `
  return itemHtml
}

Loan.prototype.formatLoans = function() {
  let loanHtml = `
    <p class="list-group-item list-group-item-action">Borrowed by ${this.user.username} on ${this.loan_date.replace(/(\d{4})\-(\d{2})\-(\d{2}).*/, '$2-$3-$1')}. Used for ${this.used_for}.</p>
  `
  return loanHtml
}

Item.prototype.buttonFooter = function () {
  let buttonHtml = `
  <button data-id="${this.id}" class="hide-loan-history badge badge-secondary">Hide Loan History</button><br>
  <button data-id="${this.id}" class="next-item badge badge-secondary">Next Item</button>
  </div>
  `
  return buttonHtml
}

Item.prototype.buttonFooterShow = function () {
  let buttonHtml = `
  <button data-id="${this.id}" class="loan-history badge badge-secondary">Show Loan History</button><br>
  <button data-id="${this.id}" class="next-item badge badge-secondary">Next Item</button>
  </div>
  `
  return buttonHtml
}

Item.prototype.newItemForm= function (user) {
  let formHtml = `
  <form class="new-item-form">
    Item name: <input type="text" id="item_name"><br>
    <input type="submit" class="new-item" value="Donate Item">
  </form>
  `
  return formHtml
}
