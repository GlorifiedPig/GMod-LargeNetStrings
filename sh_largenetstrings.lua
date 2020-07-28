
if not net.WriteLargeString then
    function net.WriteLargeString( largeString )
        local byteCount = ( string.len( largeString ) * 8 ) + 8
        net.WriteUInt( byteCount, 16 )
        net.WriteData( util.Compress( largeString ), byteCount )
    end
end

if not net.ReadLargeString then
    function net.ReadLargeString()
        local byteCount = net.ReadUInt( 16 )
        return util.Decompress( net.ReadData( byteCount ) )
    end
end