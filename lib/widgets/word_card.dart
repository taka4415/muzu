import 'package:englishapp/utils/colors.dart';
import 'package:flutter/material.dart';

class WordCard extends StatefulWidget {
  final meaning;
  const WordCard({Key? key, required this.meaning}) : super(key: key);

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.meaning['kind'] == "n"
          ? const Color.fromARGB(255, 255, 238, 193)
          : widget.meaning['kind'] == "v"
              ? Colors.red[100]
              : widget.meaning['kind'] == "a"
                  ? Colors.blue[100]
                  : Colors.green[100],
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: widget.meaning['kind'] == "n"
                  ? primaryColor
                  : widget.meaning['kind'] == "v"
                      ? Colors.red[300]
                      : widget.meaning['kind'] == "a"
                          ? Colors.blue[300]
                          : Colors.green[300],
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              child: Text(
                widget.meaning['kind'] == "v"
                    ? "動"
                    : widget.meaning['kind'] == "n"
                        ? "名"
                        : widget.meaning['kind'] == "a"
                            ? "形"
                            : "副",
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 2, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.meaning['definition'],
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.meaning['definitionjpn']
                        .toString()
                        .replaceAll("[", "")
                        .replaceAll("]", "")
                        .replaceAll("'", "")
                        .replaceAll("'", ""),
                    style: const TextStyle(fontSize: 16),
                  ),
                  widget.meaning['synonym'].length < 3
                      ? Container()
                      : Row(
                          children: [
                            widget.meaning['synonym'].length < 3
                                ? Container()
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        color: const Color.fromARGB(
                                            255, 233, 233, 233),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        child: const Text(
                                          "類語",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                widget.meaning['synonym']
                                    .toString()
                                    .replaceFirst("[", "")
                                    .replaceFirst("]", "")
                                    .replaceAll("'", ""),
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
