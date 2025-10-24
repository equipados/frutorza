object UniServerModule: TUniServerModule
  OldCreateOrder = False
  Port = 8080
  Bindings = <
    item
      IP = '0.0.0.0'
      Port = 8080
    end>
  ServerMessages.ServerBusyText = 'Procesando solicitud...'
end
