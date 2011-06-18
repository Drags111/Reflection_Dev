library RefCalculationsLib;

{$mode objfpc}{$H+}

uses
  Classes, Sysutils, math;

type
  T2DIntegerArray = array of array of Integer;

function DijkstraDist(StartX, StartY, DestX, DestY: Integer; IsObject: Boolean; Blocks: T2DIntegerArray): Integer;
var
   prev, dist: array of array of Integer;
   path_x, path_y: array of Integer;
   xx, yy, curr_x, curr_y, path_ptr, step_ptr, pathLength, goal, cost: Integer;
   foundPath: Boolean;
begin
     try
        SetLength(prev, 104);
        SetLength(dist, 104);
        for xx := 0 to 103 do
        begin
            SetLength(prev[xx], 104);
            SetLength(dist[xx], 104);
        end;
        for xx := 0 to 103 do
            for yy := 0 to 103 do
            begin
                prev[xx][yy] := 0;
                dist[xx][yy] := 99999999;
            end;

        SetLength(path_x, 4000);
        SetLength(path_y, 4000);

        curr_x := startX;
        curr_y := startY;
        prev[startX][startY] := 99;
        dist[startX][startY] := 0;
        path_ptr := 0;
	step_ptr := 0;
        path_x[path_ptr] := startX;
        path_y[path_ptr] := startY;
        Inc(path_ptr);
        pathLength := 4000;
        foundPath := false;

        case IsObject of
             true: goal := 1;
             false: goal := 0;
        end;

        while(step_ptr <> path_ptr)do
        begin
             curr_x := path_x[step_ptr];
	     curr_y := path_y[step_ptr];

             if(Abs(curr_x - destX) + Abs(curr_y - destY) = goal)then
             begin
                  foundPath := true;
                  break;
             end;

             step_ptr := (step_ptr + 1) mod pathLength;
             cost := dist[curr_x][curr_y] + 1;

             //south
             if((curr_y > 0)
                        and (prev[curr_x][(curr_y - 1)] = 0)
                        and ((blocks[(curr_x + 1)][curr_y] and $1280102) = 0))then
             begin
      	          path_x[path_ptr] := curr_x;
	          path_y[path_ptr] := curr_y - 1;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x][curr_y - 1] := 1;
		  dist[curr_x][curr_y - 1] := cost;
	     end;

             // west
	     if((curr_x > 0)
                        and (prev[curr_x - 1][curr_y] = 0)
                        and ((blocks[curr_x][curr_y + 1] and $1280108) = 0))then
             begin
      	          path_x[path_ptr] := curr_x - 1;
		  path_y[path_ptr] := curr_y;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x - 1][curr_y] := 2;
		  dist[curr_x - 1][curr_y] := cost;
	     end;

             // north
	     if((curr_y < 102)
                        and (prev[curr_x][curr_y + 1] = 0)
                        and ((blocks[curr_x + 1][curr_y + 2] and $1280120) = 0))then
             begin
	          path_x[path_ptr] := curr_x;
		  path_y[path_ptr] := curr_y + 1;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x][curr_y + 1] := 4;
		  dist[curr_x][curr_y + 1] := cost;
	     end;

             // east
	     if ((curr_x < 102)
                         and (prev[curr_x + 1][curr_y] = 0)
                         and ((blocks[curr_x + 2][curr_y + 1] and $1280180) = 0))then
             begin
	          path_x[path_ptr] := curr_x + 1;
		  path_y[path_ptr] := curr_y;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x + 1][curr_y] := 8;
		  dist[curr_x + 1][curr_y] := cost;
	     end;

             // south west
	     if((curr_x > 0) and (curr_y > 0)
                        and (prev[curr_x - 1][curr_y - 1] = 0)
                        and ((blocks[curr_x][curr_y] and $128010E) = 0)
                        and ((blocks[curr_x][curr_y + 1] and $1280108) = 0)
                        and ((blocks[curr_x + 1][curr_y] and $1280102) = 0))then
             begin
      	          path_x[path_ptr] := curr_x - 1;
		  path_y[path_ptr] := curr_y - 1;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x - 1][curr_y - 1] := 3;
		  dist[curr_x - 1][curr_y - 1] := cost;
	     end;

             // north west
	     if((curr_x > 0) and (curr_y < 102)
                        and (prev[curr_x - 1][curr_y + 1] = 0)
                        and ((blocks[curr_x][curr_y + 2] and $1280138) = 0)
                        and ((blocks[curr_x][curr_y + 1] and $1280108) = 0)
                        and ((blocks[curr_x + 1][curr_y + 2] and $1280120) = 0))then
             begin
      	          path_x[path_ptr] := curr_x - 1;
		  path_y[path_ptr] := curr_y + 1;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x - 1][curr_y + 1] := 6;
		  dist[curr_x - 1][curr_y + 1] := cost;
	     end;

             // south east
	     if((curr_x < 102) and (curr_y > 0)
                        and (prev[curr_x + 1][curr_y - 1] = 0)
                        and ((blocks[curr_x + 2][curr_y] and $1280183) = 0)
                        and ((blocks[curr_x + 2][curr_y + 1] and $1280180) = 0)
                        and ((blocks[curr_x + 1][curr_y] and $1280102) = 0))then
             begin
      	          path_x[path_ptr] := curr_x + 1;
		  path_y[path_ptr] := curr_y - 1;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x + 1][curr_y - 1] := 9;
		  dist[curr_x + 1][curr_y - 1] := cost;
	     end;

             // north east
	     if((curr_x < 102) and (curr_y < 102)
                        and (prev[curr_x + 1][curr_y + 1] = 0)
                        and ((blocks[curr_x + 2][curr_y + 2] and $12801E0) = 0)
                        and ((blocks[curr_x + 2][curr_y + 1] and $1280180) = 0)
                        and ((blocks[curr_x + 1][curr_y + 2] and $1280120) = 0))then
             begin
      	          path_x[path_ptr] := curr_x + 1;
		  path_y[path_ptr] := curr_y + 1;
		  path_ptr := (path_ptr + 1) mod pathLength;
		  prev[curr_x + 1][curr_y + 1] := 12;
		  dist[curr_x + 1][curr_y + 1] := cost;
	     end;
        end;

        if foundPath then
        begin
           Result := dist[curr_x][curr_y];
        end
        else
        Result := -1;

     except
           Result := -1;
     end;
end;

function GetFunctionCount(): Integer; stdcall; export;
begin
  Result := 1;
end;

function GetFunctionCallingConv(x : Integer) : Integer; stdcall; export;
begin
  Result := 0;
  case x of
    0 : Result := 1;
  end;
end;

function GetFunctionInfo(x: Integer; var ProcAddr: Pointer; var ProcDef: PChar): Integer; stdcall; export;
begin
  case x of
    0:
      begin
        ProcAddr := @DijkstraDist;
        StrPCopy(ProcDef, 'function DijkstraDist(StartX, StartY, DestX, DestY: Integer; IsObject: Boolean; Blocks: T2DIntegerArray) : Integer;');
      end;
  else
    x := -1;
  end;
  Result := x;
end;

exports GetFunctionCount;
exports GetFunctionInfo;
exports GetFunctionCallingConv;
exports DijkstraDist;

initialization

end.

