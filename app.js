/* app.js – loads commands.json and renders a live-searchable command list */
(function () {
  'use strict';

  const list   = document.getElementById('command-list');
  const search = document.getElementById('search');
  const count  = document.getElementById('count');

  let commands = [];

  /* ── Escape a string for safe insertion into HTML ───────── */
  function escapeHtml(str) {
    return str
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  /* ── Wrap matched substring with <mark> for highlighting ── */
  function highlight(text, query) {
    const safe = escapeHtml(text);
    if (!query) return safe;
    // Escape the query for HTML first, then for use in a RegExp,
    // so it matches against the already-HTML-escaped text string.
    const escapedQuery = escapeHtml(query).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    return safe.replace(new RegExp('(' + escapedQuery + ')', 'gi'), '<mark>$1</mark>');
  }

  /* ── Build a card element for one command ───────────────── */
  function buildCard(cmd, query) {
    const article = document.createElement('article');
    article.className = 'card';
    article.setAttribute('role', 'listitem');

    const header = document.createElement('div');
    header.className = 'card-header';

    const nameEl = document.createElement('span');
    nameEl.className = 'cmd-name';
    nameEl.innerHTML = highlight(cmd.name, query);

    header.appendChild(nameEl);

    const descEl = document.createElement('p');
    descEl.className = 'cmd-desc';
    descEl.innerHTML = highlight(cmd.description, query);

    article.appendChild(header);
    article.appendChild(descEl);

    if (Array.isArray(cmd.examples) && cmd.examples.length > 0) {
      const label = document.createElement('p');
      label.className = 'examples-label';
      label.textContent = 'Examples';

      const examplesDiv = document.createElement('div');
      examplesDiv.className = 'examples';

      cmd.examples.forEach(function (ex) {
        const pre = document.createElement('pre');
        pre.className = 'example';
        pre.innerHTML = highlight(ex, query);
        examplesDiv.appendChild(pre);
      });

      article.appendChild(label);
      article.appendChild(examplesDiv);
    }

    return article;
  }

  /* ── Render the filtered list ───────────────────────────── */
  function render(query) {
    const q = query.trim().toLowerCase();

    const filtered = q
      ? commands.filter(function (cmd) {
          return (
            cmd.name.toLowerCase().includes(q) ||
            cmd.description.toLowerCase().includes(q) ||
            (cmd.examples || []).some(function (ex) {
              return ex.toLowerCase().includes(q);
            })
          );
        })
      : commands;

    list.innerHTML = '';

    if (filtered.length === 0) {
      const msg = document.createElement('p');
      msg.className = 'no-results';
      msg.textContent = 'No commands match "' + query.trim() + '".';
      list.appendChild(msg);
    } else {
      const fragment = document.createDocumentFragment();
      filtered.forEach(function (cmd) {
        fragment.appendChild(buildCard(cmd, q));
      });
      list.appendChild(fragment);
    }

    count.textContent = filtered.length + ' / ' + commands.length + ' commands';
  }

  /* ── Debounce helper ────────────────────────────────────── */
  function debounce(fn, delay) {
    var timer;
    return function () {
      clearTimeout(timer);
      timer = setTimeout(fn, delay);
    };
  }

  /* ── Bootstrap: fetch data, then wire up search ─────────── */
  fetch('commands.json')
    .then(function (res) {
      if (!res.ok) throw new Error('Failed to load commands.json: ' + res.status);
      return res.json();
    })
    .then(function (data) {
      commands = data;
      render('');
      search.addEventListener('input', debounce(function () {
        render(search.value);
      }, 150));
    })
    .catch(function (err) {
      list.innerHTML = '<p class="no-results">⚠️ Could not load commands: ' + escapeHtml(err.message) + '</p>';
      console.error(err);
    });
}());
