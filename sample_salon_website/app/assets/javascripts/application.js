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
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

const weeks = ['日', '月', '火', '水', '木', '金', '土'];
const date = new Date();
const year = date.getFullYear();
const month = date.getMonth() + 1;
// 月の最初の日を取得
const startDate = new Date(year, month -1, 1);
//月の最後の日を取得
const endDate = new Date(year, month , 0);
// 月末の日付
const endDayCount = endDate.getDate();
// 月の最初の曜日を取得
const startDay = startDate.getDay(); 
// 日にちのカウント
let dayCount = 1;
// HTMLを雲立てる変数
let calendarHtml = '';

calendarHtml += '<h1>' + year + '/' + month + '</h1>';
calendarHtml += '<table>';

// 曜日の行を作成
for (let i = 0; i < weeks.length; i++) {
  calendarHtml += '<td>' + weeks[i] + '</td>';

  for (let d = 0; d < 7; d++) {
    if (w == 0 && d < startDay) {
      // 1行目で1日の曜日の前
      calendarHtml += '<td></td>';
    } else if (dayCount > endDayCount) {
      // 末尾の日数を超えた
      calendarHtml += '<td></td>';
    } else {
      calendarHtml += '<td>' + dayCount + '</td>'
      dayCount++;
    }
  }
  calendarHtml += '</table>';
  document.querySelector('#calendar').innerHTML = calendarHTML;
}