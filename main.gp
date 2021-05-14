dsa_pub = [Mod(16, 2359457956956300567038105751718832373634513504534942514002305419604815592073181005834416173), 589864489239075141759526437929708093408628376133735628500576354901203898018295251458604043, 2028727269671031475103905404250865899391487240939480351378663127451217489613162734122924934];
check(s, dsa_pub) = {
  my(h, r, g, q, X);
  [h, r, s] = s;
  [g, q, X] = dsa_pub;
  lift( (g^h*X^r)^(1/s % q) ) % q == r;
}


signatures = readvec("input.txt");
[g,q,X] = dsa_pub;
p = g.mod;


\\ Recherche de collision
\\ si une même valeur k a été utilisée pour signer m et m',
\\ alors le r_k obtenu est le même pour les deux signatures.

\\ On va chercher deux signatures qui ont le même r, et donc le même k


collision = {

  my(res);

  for(i = 1, #signatures -1,
    r1 = signatures[i][2];
    for(j = 2, #signatures,
      r2 = signatures[j][2];
      if(r1 == r2,
        res = r2;
      );
    );
  );
  return res;
}

\\ AUCUNE COLLISION





collision_forcee1() = {
  for(k = 1, 10^10-1,
    r_k = lift(Mod(lift(g^k), q));
    for(i = 1, #signatures,
      if(r_k == signatures[i][2],
        [h,r,s] = [signatures[i][1], signatures[i][2], signatures[i][3]];
        break;
      );
    );
  );

  \\ Une fois qu'un k qui correspond à une des signatures est trouvé, on peut utilise la formule de calcul de s pour retrouver x
  \\ s = k^(-1) * (h + x*r) mod q <=> (s*k - h) * r^(-1) = x mod q

  x = lift( Mod(lift((s*k -h) * r^(-1)), q) );
  print(x);
}

\\ TROP LONG






/*
Maps.
create empty dictionnary : M = Map()
attach value v to key k mapput(M, k, v)
recover value attach to key k or error mapget(M, k)
is keykin the dict ? mapisdefined(M, k)
remove k from map domain mapdelete(M, k)
*/


/*
collision_forcee2() = {

  \\ On crée une Map pour mapisdefined plus rapide qu'une recherche dans un vecteur 'classique'
  signatures_map = Map();
  for(i = 1, #signatures,
    mapput(signatures_map, signatures[i][2], signatures[i])
  );

  for(k = 2, 10^10-1,
    r_k = lift(Mod(lift(g^k), q));
    print(k);
    if(mapisdefined(signatures_map, r_k),
      [h,r,s] = mapget(signatures_map, r_k),
      print([h,r,s]);
      break;
    )
  );

  x = lift( Mod(lift((s*k -h) * r^(-1)), q) );
  print(x);
}

*/

\\ NE FONCTIONNE PAS



collision_forcee3() = {

  \\ On crée une Map pour mapisdefined plus rapide qu'une recherche dans un vecteur 'classique'
  signatures_map = Map();
  for(i = 1, #signatures,
    mapput(signatures_map, signatures[i][2], signatures[i])
  );

  tmp = 0;
  while(tmp == 0,
    k = random(10^10-1)+1;
    r_k=lift(Mod(lift(g^k),q));
    if(mapisdefined(signatures_map, r_k),
      tmp = 1;
    [h,r,s] = mapget(signatures_map,r_k);
    );
  );

  x = lift( Mod(lift((s*k -h) * r^(-1)), q) );
  print(x);
}

collision_forcee3();
