import {Socket} from "deps/phoenix/web/static/js/phoenix"

let socket = new Socket("/socket")

socket.connect()

export default socket
