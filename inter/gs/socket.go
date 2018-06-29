package gs

import (
	"errors"
	"net"
	"strings"

	"github.com/Synaxis/Hydra/inter/log"
)

// Socket is a basic event-based TCP-Server
type Socket struct {
	Clients   []*Client
	name      string
	port      string
	listen    net.Listener
	eventChan chan SocketEvent
	fesl      bool
}

type EventError struct {
	Error error
}
type EventNewClient struct {
	Client *Client
}

type EventClientClose struct {
	Client *Client
}
type EventClientError struct {
	Client *Client
	Error  error
}
type EventClientCommand struct {
	Client  *Client
	Process *Process
}
type EventClientFESLCommand struct {
	Client  *Client
	Process *CommandFESL
}
type EventClientData struct {
	Client *Client
	Data   string
}


type SocketEvent struct {
	Name string
	Data interface{}
}

// New starts to listen on a new Socket
func (socket *Socket) New(name string, port string, fesl bool) (chan SocketEvent, error) {
	var err error

	socket.name = name
	socket.port = port
	socket.eventChan = make(chan SocketEvent, 1000)
	socket.fesl = fesl

	// Listen for incoming connections.
	socket.listen, err = net.Listen("tcp", "0.0.0.0:"+socket.port)
	if err != nil {
		log.Errorf("%s:Port:%s error.\n%v", socket.name, socket.port, err)
		return nil, err
	}
	log.Noteln(socket.name + ":Port:" + socket.port)

	// Accept new connections in a new Goroutine("thread")
	go socket.run()

	return socket.eventChan, nil
}

// Close fires a close-event and closes the socket
func (socket *Socket) Close() {
	// Fire closing event
	log.Noteln(socket.name + " closing. Port " + socket.port)
	socket.eventChan <- SocketEvent{
		Name: "close",
		Data: nil,
	}

	// Close socket
	socket.listen.Close()
}

func (socket *Socket) run() {
	for {
		// Listen for an incoming connection.
		conn, err := socket.listen.Accept()
		if err != nil {
			log.Errorf("%s: New client connecting error.\n%v", socket.name, err)
			socket.eventChan <- SocketEvent{
				Name: "error",
				Data: EventError{
					Error: err,
				},
			}
			continue
		}

		// Create a new Client and add it to our slice
		log.Noteln(socket.name + ": Client Connected")
		newClient := new(Client)
		if socket.fesl {
			newClient.FESL = true
		}
		clientEventSocket, err := newClient.New(socket.name, &conn)
		if err != nil {
			log.Errorf("%s: Creating new client error.\n%v", socket.name, err)
			socket.eventChan <- SocketEvent{
				Name: "error",
				Data: EventError{
					Error: err,
				},
			}
		}
		go socket.handleClientEvents(newClient, clientEventSocket)

		socket.Clients = append(socket.Clients, newClient)

		// Fire newClient event
		socket.eventChan <- SocketEvent{
			Name: "newClient",
			Data: EventNewClient{
				Client: newClient,
			},
		}
	}
}

func (socket *Socket) removeClient(client *Client) error {
	var indexToRemove = 0
	var foundClient = false

	log.Println("Removing client ", client)

	client.IsActive = false
	(*client.conn).Close()

	for i := range socket.Clients {
		if socket.Clients[i] == client {
			indexToRemove = i
			foundClient = true
			break
		}
	}

	if !foundClient {
		return errors.New("could not find client to remove")
	}

	log.Println("Found client ", indexToRemove)

	if len(socket.Clients) == 1 {
		// We have only one element, so create a new one
		socket.Clients = []*Client{}
		return nil
	}

	// Replace our client set to remove with the last client in the array
	// and then cut the last element of the array
	socket.Clients[indexToRemove] = socket.Clients[len(socket.Clients)-1]
	socket.Clients = socket.Clients[:len(socket.Clients)-1]

	log.Println("Client removed")
	return nil
}

func (socket *Socket) handleClientEvents(client *Client, eventsChannel chan ClientEvent) {
	for client.IsActive {
		select {
		case event := <-eventsChannel:
			switch {
			case event.Name == "close":
				socket.eventChan <- SocketEvent{
					Name: "client." + event.Name,
					Data: EventClientClose{
						Client: client,
					},
				}
				err := socket.removeClient(client)
				if err != nil {
					log.Errorln("Could not remove client", err)
				}
			case strings.Index(event.Name, "command") != -1:
				if socket.fesl {
					socket.eventChan <- SocketEvent{
						Name: "client." + event.Name,
						Data: EventClientFESLCommand{
							Client:  client,
							Process: event.Data.(*CommandFESL),
						},
					}
				} else {
					socket.eventChan <- SocketEvent{
						Name: "client." + event.Name,

						Data: EventClientCommand{
							Client:  client,
							Process: event.Data.(*Process),
						},
					}
				}
			case event.Name == "data":
				socket.eventChan <- SocketEvent{
					Name: "client." + event.Name,
					Data: EventClientData{
						Client: client,
						Data:   event.Data.(string),
					},
				}

			default:
				var interfaceSlice = make([]interface{}, 2)
				interfaceSlice[0] = client
				interfaceSlice[1] = event.Data

				// Send the event down the chain
				socket.eventChan <- SocketEvent{
					Name: "client." + event.Name,
					Data: interfaceSlice,
				}
			}
			/*default:
			if !client.IsActive {
				break
			}
			runtime.Gosched()*/
		}
	}

	socket.removeClient(client)
}
