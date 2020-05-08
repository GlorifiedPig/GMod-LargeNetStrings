
if SERVER then
    local function chunkstring( str, number )
        local output = {}
        local strsize = string.len( str )
        local chunksTaken = 0
        local chunksToTake = math.ceil( strsize / number )
        for i = 1, chunksToTake do
            if chunksTaken == chunksToTake - 1 then
                table.insert( output, string.sub( str, chunksTaken * number ) )
            else
                table.insert( output, string.sub( str, chunksTaken * number, i * number ) )
            end
            chunksTaken = chunksTaken + 1
        end
        return output
    end

    function net.WriteLargeString( largeString )
        local chunksToSend = math.ceil( string.len( largeString ) / 8000 )
        local chunksTbl = chunkstring( largeString, 8000 )
        net.WriteUInt( chunksToSend, 4 ) -- send how many chunks we are supposed to be receiving for an appropriate clientsided for loop
        for i = 1, chunksToSend do
            local bufferSize = ( string.len( chunksTbl[i] ) * 8 ) + 8
            net.WriteUInt( bufferSize, 6 )
            net.WriteData( util.Compress( chunksTbl[i] ), bufferSize ) -- 8000 max chars * 8 + 8 for bytecount
        end
    end
else
    function net.ReadLargeString()
        local largeString = ""
        local chunksToReceive = net.ReadUInt( 4 )
        for i = 1, chunksToReceive do
            local bufferSize = net.ReadUInt( 6 )
            local readData = net.ReadData( bufferSize )
            readData = util.Decompress( readData )
            largeString = largeString .. readData
        end
        return largeString
    end
end