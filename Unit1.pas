unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Bluetooth,
  System.Bluetooth.Components, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    Memo2: TMemo;
    Button1: TButton;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
      FSocket: TBluetoothSocket;
      FBluetoothManager: TBluetoothManager;
      FDiscoverDevices: TBluetoothDeviceList;
      FPairedDevices: TBluetoothDeviceList;
      FAdapter: TBluetoothAdapter;
      FData: TBytes;
      ItemIndex: Integer;
      servicegui, servicename: string;
      LDevice: TBluetoothDevice;
      GUID: TGuid;
      bluetooth: TBluetoothDeviceList;
      LServices: TBluetoothServiceList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var

  ToSend: TBytes;
  Msg, Texto: String;
  a : integer;
begin
    timer1.Enabled := true;
    Memo1.Lines.Add('Port :' + BoolToStr(LDevice.IsPaired));
    Memo1.Lines.Add('Guide:' + GUIDToString(Guid));

    if (Assigned(LDevice)) And (Assigned(FSocket))
    then Begin
         if Not FSocket.Connected
         then FSocket.Connect
         End
    Else Begin
         FSocket := LDevice.CreateClientSocket(Guid, True);
         Memo1.Lines.Add('Device Socked created to '+LDevice.DeviceName);
         FSocket.Connect;
    End;

end;

procedure TForm1.FormActivate(Sender: TObject);
var
  Msg, Texto: string;
  I, B: Integer;
  BluetoothAdapter: TBluetoothAdapter;
  bluetooth: TBluetoothDeviceList;
  LServices: TBluetoothServiceList;
begin
  try
    Memo1.Lines.Add('Ok 1');
    FBluetoothManager := TBluetoothManager.Current;
    if FBluetoothManager = nil then
      Memo1.Lines.Add('FBluetoothManager ini nol');

    Memo1.Lines.Add('Ok 2');
    BluetoothAdapter := FBluetoothManager.CurrentAdapter;
    if BluetoothAdapter = nil then
    Memo1.Lines.Add('BluetoothAdapter ini nol');

    bluetooth := BluetoothAdapter.PairedDevices;
    Memo1.Lines.Add('Ok 3');
    if bluetooth = nil then
      Memo1.Lines.Add('bluetooth ini nol');

    for I := 0 to bluetooth.Count - 1 do
    begin
      LDevice := bluetooth[I] as TBluetoothDevice;
      if LDevice.IsPaired then
      begin
        LServices := LDevice.GetServices;
        for B := 0 to LServices.Count - 1 do
        begin
          ServiceGUI := GUIDToString(LServices[B].UUID);
          Guid := LServices[B].UUID;
          ServiceName := LServices[B].Name;
          Memo1.Lines.Add(LServices[B].Name + ' --> ' + ServiceGUI);
          Memo1.GoToTextEnd;
          if LServices[B].Name = 'SerialPort' then exit;
        end;
      end;
    end;;


  except
   on E: Exception do
   begin
     Msg := E.Message;
     Memo1.Lines.Add('Error Message: ' + Msg);
     Memo1.GoToTextEnd;
   end;
 end;
end;



procedure TForm1.Timer1Timer(Sender: TObject);
var

  ToSend: TBytes;
  Msg, Texto ,spasi: String;
  a,konter : integer;
begin

if Assigned(FSocket)
then Begin
     if FSocket.Connected
     then Begin
        //-------- judul  12

            for  a := 1 to 3   do
            begin

              Texto :=  Memo2.Lines.Text+  #27#13#10;
              ToSend := TEncoding.UTF8.GetBytes(Texto);
              FSocket.SendData(ToSend);
            end;

         End;
         timer1.Enabled := false;
         end;

end;

end.
