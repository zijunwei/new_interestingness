function output=z_entropy(fdm)
fdm=fdm(:);

output=-sum(fdm.*log2(fdm));

end