
                        return GestureDetector(
                          onTap: () {
                            inmyqrs
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VierMyQr(
                                            imageUrl: snapshot.data.toString(),
                                            item: item)),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MoreQr(
                                            imageUrl: snapshot.data.toString(),
                                            item: item)),
                                  );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Card(
                              // shadowColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    width: 100,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0),
                                      ),
                                      child: Skeleton.replace(
                                        width: 100,
                                        height: 200,
                                        child: snapshot.data != null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    snapshot.data.toString(),
                                                fit: BoxFit.cover,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10.0, 20.0, 0, 0),
                                        child: Text(
                                          "#${item['qr_code_id']}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );