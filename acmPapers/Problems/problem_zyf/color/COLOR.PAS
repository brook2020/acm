{$R-,S-,Q-}

const
  MaxN          =100;{��������}
  MaxL          =100;{������ĳ���}
  Finp          ='Input.txt';
  Fout          ='Output.txt';

type
  TStr          =string[MaxL];
  TSquare       =array[1..MaxL,1..MaxL] of Byte;

var
  F             :TSquare;{�����ⱨ���еĺ���F}
  G             :array['A'..'Z'] of ^TSquare;{�����ⱨ���еĺ���g}
  H             :array['A'..'Z'] of Byte;{��̬�滮�еĸ�������}
  Map           :array['A'..'Z','A'..'Z'] of Byte;{Map[i,j]��ʾ��ɫi�����ɫj�����ٲ���}
  n             :Integer;{������}
  C             :array[1..MaxN] of Char;{C[i]��ʾ��i���Լ���ԭɫ}
  S             :array[0..MaxN] of TStr;{S[i]��ʾ��i���Լ���Ŀ��ɫ����}
  Start,Goal    :TStr;{Start�ǽ������ʼ��ɫ����,Goal������ɫ����}
  Answer        :Integer;{������}

procedure GetInfo;{�����ļ�}
  var
    i   :Integer;
    Fn  :string;
  begin
    Assign(Input,Finp);Reset(Input);
    Readln(n);
    Readln(Start);
    Readln(Goal);
    for i:=1 to n do begin
      Read(C[i]);
      Readln(S[i])
    end;
    S[0]:=Start;
    Close(Input)
  end;

procedure Prepare;{����ͼG���������·��}
  var
    i,j,k       :Char;
    p           :Integer;
  begin
    FillChar(Map,Sizeof(Map),$7F);
    for p:=1 to n do if Length(S[p])=1 then Map[C[p],S[p,1]]:=1;
    for i:='A' to 'Z' do Map[i,i]:=0;
    for k:='A' to 'Z' do
      for i:='A' to 'Z' do
        for j:='A' to 'Z' do
          if Map[i,k]+Map[k,j]<Map[i,j] then Map[i,j]:=Map[i,k]+Map[k,j];
    for i:='A' to 'Z' do begin
      New(G[i]);
      FillChar(G[i]^,Sizeof(G[i]^),$7F)
    end;
    for p:=1 to Length(Goal) do
      for i:='A' to 'Z' do
        if Map[i,Goal[p]]<G[i]^[p,1] then G[i]^[p,1]:=Map[i,Goal[p]]
  end;

procedure Main;{��̬�滮}
  var
    i,k,st,l,ll,p,x,Min :Integer;
    Quit                :Boolean;
    ci,cj               :Char;
  begin
    for l:=1 to Length(Goal) do
      for st:=1 to Length(Goal)-l+1 do begin
        for ci:='A' to 'Z' do H[ci]:=$7F-1;
        for i:=n downto 0 do begin
          F[Length(S[i]),l]:=$7F;
          for k:=1 to l do F[1,k]:=G[S[i,1]]^[st,k];{F�����ʼ��}
          for k:=2 to l do
            if k<=Length(S[i]) then begin
              Quit:=True;
              for ll:=k to l do begin
                Min:=$7F;
                for p:=k-1 to ll-1 do begin
                  x:=F[k-1,p]+G[S[i,k]]^[st+p,ll-p];{״̬��ת��}
                  if x<Min then begin
                    Min:=x;
                    Quit:=False
                  end
                end;
                F[k,ll]:=Min
              end;
              if Quit then Break
            end;
          Min:=F[Length(S[i]),l];
          if (i>=1) and (Min<H[C[i]]) then H[C[i]]:=Min
        end;
        for ci:='A' to 'Z' do begin{ͨ�������·��������"��"}
          Inc(H[ci]);
          for cj:='A' to 'Z' do begin
            x:=Map[cj,ci]+H[ci];
            if x<G[cj]^[st,l] then G[cj]^[st,l]:=x
          end
        end;
        for k:=1 to l do F[1,k]:=G[S[0,1]]^[st,k]
      end;
    Answer:=F[Length(Start),Length(Goal)]
  end;

procedure Print;{���}
  begin
    Assign(Output,Fout);Rewrite(Output);
    if Answer=$7F then Writeln(-1) else Writeln(Answer);
    Close(Output)
  end;

begin
  GetInfo;
  Prepare;
  Main;
  Print
end.