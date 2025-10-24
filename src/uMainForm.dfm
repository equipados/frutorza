object MainmForm: TMainmForm
  Caption = 'Lector de Etiquetas'
  OnCreate = UnimFormCreate
  object pnlHeader: TUnimPanel
    Align = alTop
    Height = 48
    TabOrder = 0
    object lblTitle: TUnimLabel
      Align = alClient
      Caption = 'Lector de Lotes'
    end
  end
  object pnlContent: TUnimPanel
    Align = alClient
    TabOrder = 1
    object btnCapture: TUnimButton
      Align = alTop
      Height = 60
      Caption = 'Capturar etiqueta'
      OnClick = btnCaptureClick
      TabOrder = 0
    end
    object Upload: TUnimFileUpload
      Left = 0
      Top = 64
      Width = 100
      Height = 32
      Visible = False
      OnCompleted = UploadCompleted
    end
    object memResult: TUnimMemo
      Align = alClient
      ReadOnly = True
      EmptyText = 'Los resultados aparecerán aquí'
      TabOrder = 1
    end
  end
end
