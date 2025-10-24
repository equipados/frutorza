object MainmForm: TMainmForm
  Caption = 'Lector de Etiquetas'
  OnCreate = UnimFormCreate
  LayoutConfig.Height = '100%'
  LayoutConfig.Width = '100%'
  Layout = 'fit'
  object pnlHeader: TUnimPanel
    Align = alTop
    Height = 48
    Layout = 'hbox'
    LayoutConfig.Cls = 'x-toolbar-dark'
    object lblTitle: TUnimLabel
      Align = alClient
      Caption = 'Lector de Lotes'
      LayoutConfig.Cls = 'unim-text-bold'
    end
  end
  object pnlContent: TUnimPanel
    Align = alClient
    Layout = 'vbox'
    LayoutConfig.Align = 'stretch'
    LayoutConfig.Pack = 'center'
    LayoutConfig.Padding = '12'
    object btnCapture: TUnimButton
      Caption = 'Capturar etiqueta'
      OnClick = btnCaptureClick
      LayoutConfig.Width = '100%'
    end
    object Upload: TUnimFileUpload
      Visible = False
      OnCompleted = UploadCompleted
    end
    object memResult: TUnimMemo
      Align = alClient
      ReadOnly = True
      EmptyText = 'Los resultados aparecerán aquí'
      LayoutConfig.Grow = 1
    end
  end
end
