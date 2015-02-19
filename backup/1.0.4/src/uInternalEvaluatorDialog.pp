unit uInternalEvaluatorDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ComCtrls, uShowResultsDialog, Process;

type

  { TInternalEvaluatorDialog }

  TInternalEvaluatorDialog = class(TForm)
    CancelButton: TButton;
    EntireProgressLabel: TLabel;
    ProgressBar: TProgressBar;
    StatusLabel: TLabel;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    Messages:TStringList;
    evaluating:boolean;
    function GetTemporaryFolder():string;
  public
    { public declarations }
    function Execute(inputfiles,outputfiles:TStrings;inputname,outputname:string;progname:string;timelimit:integer;verifier:string):boolean;
  end; 

var
  InternalEvaluatorDialog: TInternalEvaluatorDialog;

implementation

function TInternalEvaluatorDialog.GetTemporaryFolder():string;
begin
     {$ifdef win32}
     Result:=GetEnvironmentVariable('TEMP');
     {$endif}
end;

procedure TInternalEvaluatorDialog.FormCreate(Sender: TObject);
begin
  Messages:=TStringList.Create();
end;

procedure TInternalEvaluatorDialog.CancelButtonClick(Sender: TObject);
begin
  if evaluating then
   begin
    Messages.Add('Error: Stopped by user');
    evaluating:=false;
    CancelButton.Caption:='View Results';
   end          else
   begin
    Visible:=false;
    ShowResultsDialog.Execute(Messages);
    Close();
   end;
end;

procedure TInternalEvaluatorDialog.FormDestroy(Sender: TObject);
begin
  Messages.Destroy();
end;

function CpFile(src,dst:string):boolean;
const buffsize=512;
var buffer:array[0..buffsize-1] of char;
    br:integer;
    i,o:integer;
begin
     try
      i:=FileOpen(src,fmOpenRead);
      if FileExists(dst) then o:=FileOpen(dst,fmOpenWrite)
                         else o:=FileCreate(dst);
      FileTruncate(o,0);
      repeat
       br:=FileRead(i,buffer,buffsize);
       FileWrite(o,buffer,br);
      until br=0;
      
      FileClose(i);
      FileClose(o);
      
     except
      Result:=false;
     end;
end;

function FileCmp(f1n,f2n:string):boolean;
const junkdata=[' ',#13,#10,#9];//for now only ignore spaces, newlines and tabs
var f,g:text;
    done:boolean=false;
    c1,c2:char;
begin
     try
      assign(f,f1n);
      assign(g,f2n);
      reset(f);
      reset(g);
      
      repeat
       repeat
        read(f,c1);
       until (eof(f))or(not(c1 in junkdata));
       if eof(f) then c1:=#0;
       repeat
        read(g,c2);
       until eof(g) or(not(c2 in junkdata));
       if eof(g) then c2:=#0;
       if c1<>c2 then
        begin
         close(f);
         close(g);
         exit(false);
        end;
      until (eof(f))and(eof(g));
      result:=true;
      
      close(f);
      close(g);
     except
      Result:=false;
     end;
end;

function TInternalEvaluatorDialog.Execute(inputfiles,outputfiles:TStrings;inputname,outputname:string;progname:string;timelimit:integer;verifier:string):boolean;
const ds={$ifdef win32}'\'{$else}'/'{$endif};
var score,rt,t,t2,i:integer;
    tmpdir:string;
    p:TProcess;
    v:TProcess;//Verifier
begin
     score:=0;
     Visible:=true;
     evaluating:=true;
     Messages.Clear();
     StatusLabel.Caption:='Status: Analyzing';
     Application.ProcessMessages();
     if (verifier='')and(inputfiles.Count<>outputfiles.Count) then Messages.Add('Error: The number of tests does not match the number of results');
     if inputname='' then Messages.Add('Error: Pipe input is not yet supported. Please specify an input file name)');
     if outputname='' then Messages.Add('Error: Pipe output is not yet supported. Please specify an output file name');
     if progname='' then Messages.Add('Error: You must specify a program file');
     if Messages.Count<>0 then
      begin
       Messages.Add('Fatal: Could not proceed. Fix the above errors and try again');
       evaluating:=false;
       CancelButton.Caption:='View Results';
       Visible:=false;
       ShowModal();
       exit(false);
      end;
     tmpdir:=GetTemporaryFolder();
     //proceed with evaluation
     if not CpFile(progname,tmpdir+ds+ExtractFileName(progname)) then
      begin
       Messages.Add('Fatal: Could not copy '+progname+' to '+tmpdir+ds+ExtractFileName(progname)+'. Stopping');
       evaluating:=false;
       CancelButton.Caption:='View Results';
       Visible:=false;
       ShowModal();
       exit(false);
      end;

     ProgressBar.Max:=inputfiles.Count;
     for i:=0 to inputfiles.Count-1 do
      begin
       StatusLabel.Caption:='Status: Performing  test '+IntToStr(i+1)+'/'+IntToStr(inputfiles.Count);
       ProgressBar.Position:=i;
       Application.ProcessMessages();
       if not CpFile(inputfiles[i],tmpdir+ds+inputname) then
        begin
         Messages.Add('Fatal: Could not open '+tmpdir+ds+inputname+' for writing. Stopping');
         evaluating:=false;
         CancelButton.Caption:='View Results';
         Visible:=false;
         ShowModal();
         exit(false);
        end;
       if (FileExists(tmpdir+ds+outputname))and(not DeleteFile(tmpdir+ds+outputname)) then
        begin
         Messages.Add('Fatal: Could not open '+tmpdir+ds+outputname+' for writing. Stopping');
         evaluating:=false;
         CancelButton.Caption:='View Results';
         Visible:=false;
         ShowModal();
         exit(false);
        end;
       //run the program
       p:=TProcess.Create(self);
       p.Options:=[poUsePipes,poRunSuspended,poNoConsole];
       {$ifdef win32}
       p.ShowWindow:=swoHide;
       {$endif}
       p.CommandLine:=tmpdir+ds+ExtractFileName(progname);
       p.CurrentDirectory:=tmpdir;
       p.Execute();
       t:=DateTimeToTimeStamp(Now()).Time;
       p.Resume();
       while p.Running do
        begin
         Application.ProcessMessages();
         if not evaluating then
          begin
           p.Terminate(6666);
           p.Destroy();
           Visible:=false;
           ShowModal();
           exit(false);
          end;
         sleep(10);
         t2:=DateTimeToTimeStamp(Now()).Time;
         rt:=t2-t;
         if rt<0 then rt+=1000*60*60*24;
         if rt>timelimit then
          begin
           p.Terminate(6666);
           Messages.Add('Test '+IntToStr(i+1)+': Time Limit Exceeded ('+IntToStr(rt)+')');
          end;
        end;
       if (p.ExitStatus<>0)and(p.ExitStatus<>6666) then Messages.Add('Test '+IntToStr(i+1)+': Non-zero exit code: '+IntToStr(p.ExitStatus))
                                                   else
        begin
         //check files
         if not FileExists(tmpdir+ds+outputname) then Messages.Add('Test '+IntToStr(i+1)+': Missing output file ('+outputname+')')
                                                 else
          begin
           //fucking finally
           if not FileCmp(tmpdir+ds+outputname,outputfiles[i]) then Messages.add('Test '+IntToStr(i+1)+': Wrong answer')
                                              else
            begin
             Messages.Add('Test '+IntToStr(i+1)+': Okay');
             inc(score);
            end;
          end;
        end;
       p.Destroy();
      end;
     //tidy up
     DeleteFile(tmpdir+ds+ExtractFileName(progname));
     DeleteFile(tmpdir+ds+inputname);
     DeleteFile(tmpdir+ds+outputname);
     evaluating:=false;
     Messages.Add('Evaluation completed. Score: '+IntToStr(score)+'/'+IntToStr(inputfiles.Count)+'('+IntToStr(score*100 div inputfiles.Count)+'%)');
     CancelButton.Caption:='View Results';
     Visible:=false;
     ShowModal();
end;

initialization
  {$I uInternalEvaluatorDialog.lrs}

end.


