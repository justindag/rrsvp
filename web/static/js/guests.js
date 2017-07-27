let Guest = {
  init(socket, element){
    if (!element) {
      return
    }
    let eventId = element.getAttribute("data-id");
    socket.connect();
    this.onReady(eventId, socket)
  },

  onReady(eventId, socket){
    let guestsContainer = document.getElementById("guest-container");
    //let id = document.getElementById("guest-id");
    let name = document.getElementById("guest-name");
    let status = document.getElementById("guest-status");
    let email = document.getElementById("guest-email");
    let phone = document.getElementById("guest-phone");
    let addlGuests = document.getElementById("guest-addl");

    let postButton = document.getElementById("msg-submit");
    let repliesChannel = socket.channel("replies:" + eventId);

    if (postButton) {
      // push reply
      postButton.addEventListener("click", e => {
        let payload = {
          name: name.value,
          status: status.value,
          email: email.value,
          phone: phone.value,
          additional_guests: addlGuests.value,
          event_id: eventId
        };
        repliesChannel.push("new:reply", payload)
          .receive("error", e => console.log(e));
        });
    }

    // receive reply
    repliesChannel.on("new:reply", (resp) => {
      // console.log("NEW REPLY: "+JSON.stringify(resp));
      repliesChannel.params.last_seen_id = resp.id;
      this.renderGuest(guestsContainer, resp)
    });

    // 'connect'
    repliesChannel.join()
      .receive("ok", resp => {
        console.log("JOINED...: "+JSON.stringify(resp));
        resp.guests.forEach(g => this.renderGuest(guestsContainer, g))

        // let ids = resp.guests.map(g => g.id);
        // if (ids.length > 0) { repliesChannel.params.last_seen_id = Math.max(...ids) }
     })
      .receive("error", reason => console.log("join failed", reason) )
  },

  renderGuest(msgContainer, {name, status, email}){
    if (msgContainer) {
      let template = document.createElement("div");
      template.innerHTML = `<b>${this.esc(name)}</b>: ${this.esc(status)}`;
      msgContainer.insertBefore(template, msgContainer.firstChild);
      msgContainer.scrollTop = msgContainer.scrollHeight
    }
  },

  esc(str) {
    let div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML
  }

};

export default Guest
