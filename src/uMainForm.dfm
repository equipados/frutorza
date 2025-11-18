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
    LayoutConfig.Pack = 'start'
    LayoutConfig.Padding = '12'
    object pnlAction: TUnimPanel
      Layout = 'vbox'
      LayoutConfig.Align = 'stretch'
      LayoutConfig.Padding = '12'
      LayoutConfig.Width = '100%'
      object lblIntro: TUnimLabel
        Align = alTop
        Caption = 'Captura la etiqueta y extrae los datos del lote'
        LayoutConfig.Cls = 'unim-text'
      end
      object btnCapture: TUnimButton
        Caption = 'Capturar etiqueta'
        OnClick = btnCaptureClick
        LayoutConfig.Width = '100%'
        LayoutConfig.Margin = '8 0 0 0'
      end
      object Upload: TUnimFileUpload
        Visible = False
        OnCompleted = UploadCompleted
      end
    end
    object pnlResult: TUnimPanel
      Align = alClient
      Layout = 'vbox'
      LayoutConfig.Align = 'stretch'
      LayoutConfig.Flex = 1
      LayoutConfig.Margin = '12 0 0 0'
      LayoutConfig.Padding = '12'
      object lblResults: TUnimLabel
        Align = alTop
        Caption = 'Resultado'
        LayoutConfig.Cls = 'unim-text-bold'
      end
      object memResult: TUnimMemo
        Align = alClient
        ReadOnly = True
        EmptyText = 'Los resultados aparecerán aquí'
        LayoutConfig.Grow = 1
      end
    end
  end
end
