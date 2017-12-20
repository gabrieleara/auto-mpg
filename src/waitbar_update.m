function waitbar_update(x,h)
    if ~ishandle(h)
        error('Script aborted by user!');
    end
    
    waitbar(x,h);
end