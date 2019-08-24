* need better terminology
* add broadcast_from/subscribe_to so that messages can have explicit 
    tower ids

* check how easy it is to set up multiple towers using PG2
    * this would most likely use application config persistance so
        that when it fails, it can start up correctly the next time

* broadcast_id is a rubbish term and should be expanded more into an radio name
* telco might want to be renamed into something more radio based

* finish writing the documentation for the example task

* add a beacon feature that constantly outputs data at the specified rate
    (this may want to me separated out into a different application `Telco.Beacon`)

* add in direct messaging
    `Telco.Direct`